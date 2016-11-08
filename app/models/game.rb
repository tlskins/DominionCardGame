class Game < ActiveRecord::Base
  has_one :gamemanager, dependent: :destroy
  has_many :players, dependent: :destroy
  has_one :supply, class_name: "Deck", foreign_key: "game_id", dependent: :destroy
  has_one :trash, class_name: "Deck", foreign_key: "game_id", dependent: :destroy

    # Returns a string containing a list of all the users currently playing in this game
    def get_player_list
      players.map { |p| "Player " + p.turn_order.to_s + ": " + p.name + " | " }.join.to(-3)
    end

    # Updates the status of the game to "Finished" and cleans up any unnecessary data
    def end_game
      update_attributes(status: "Finished" )
    end

    # Creates a player for the provided user_id and adds them to this game
    def add_user_to_game(user_id)
      players.create!(user_id: user_id, turn_order: ( (players.maximum('turn_order') || 0) + 1) )
    end

    # Returns a new game with new created players from the array of users passed to this method
    def Game.create_game_for(user_array)
      game = Game.create(status: "In Progress")
      # Randomize turn order - ensure the creator is the first player and randomize other players order
      game_creator = user_array[0]
      opponents_array = user_array[1..(user_array.length-1)]
      players_array = opponents_array.shuffle.insert(0, game_creator)
      turn_order_counter = 1
      # Create players for each user
      players_array.each do |u|
        game.players.create(user_id: u.id, turn_order: turn_order_counter)
        turn_order_counter += 1
      end 
      # Create gamemanager
      game.create_gamemanager(phase: "Action", actions: 1, treasure: 0, buys: 1, player_turn: game.players.find_by(turn_order: 1).id)
      # Initialize Supply counts
      game.gamemanager.initialize_supply_count("Copper", 15)
      game.gamemanager.initialize_supply_count("Silver", 15)
      game.gamemanager.initialize_supply_count("Gold", 15)
      game.gamemanager.initialize_supply_count("Estate", 15)
      game.gamemanager.initialize_supply_count("Duchy", 15)
      game.gamemanager.initialize_supply_count("Province", 15)
      game.gamemanager.initialize_supply_count("Village", 15)
      game.gamemanager.initialize_supply_count("Laboratory", 15)
      game.gamemanager.initialize_supply_count("Council Room", 15)
      game.gamemanager.initialize_supply_count("Festival", 15)
      game.gamemanager.initialize_supply_count("Cellar", 15)
      game.gamemanager.initialize_supply_count("Mine", 15)
      game.gamemanager.initialize_supply_count("Bureaucrat", 15)
      # Returns game
      return game
    end

    # Creates decks for supply and players and intial cards for all the players
    def initialize_player_cards
      create_supply_decks
      players.each do |p|
        create_player_decks(p)
        create_player_cards(p)
        p.draw_card(5)
      end
    end

    # Creates a hash of the supply card object as the key value and the count in the supply as the value
    def generate_supply_cards_hash
      unless self.gamemanager.supply_count.nil?
        @supply_cards_hash = {}
        self.gamemanager.supply_count.each do |key, value|
          mapping = Cardmapping.find_by(name: key)
          @supply_cards_hash.store( mapping.name, { "cost" => mapping.cost, "text" => mapping.text, "count" => value } )
          if mapping.is_treasure
            @supply_cards_hash[mapping.name].store( "treasure_amount", mapping.treasure_amount )
          end
          if mapping.is_victory
            @supply_cards_hash[mapping.name].store( "victory_points", mapping.victory_points )
          end
        end
      end
      return @supply_cards_hash
    end

    # Return an array listing the name of supply cards that match the provided parameters 
    def generate_selectable_supply_array(type = nil, min_cost = nil, max_cost = nil, names_array = nil)
      query = ""

      # check by type
      query = query + " and is_" + type.downcase + " = 't'" unless type.nil?
      # check by min cost
      query = query + " and cost >= " + min_cost.to_s unless min_cost.nil?
      # check by max cost
      query = query + " and cost <= " + max_cost.to_s unless max_cost.nil?
      # check by name
      unless names_array.nil?
        query = query + " and name in ("
        count = 0
        names_array.each do |n|
          count = count + 1
          query = query + "'" + n + "'"
          query = query + "," unless count == names_array.length
        end
        query = query + ")"
      end

      unless query.blank?
        query.prepend("select name from cardmappings where 1=1")
        # check only for cards that exist in the current games supply
        query = query + " and name in ('" + self.gamemanager.supply_count.keys.join("','") + "')"
        mappings_objs = Cardmapping.find_by_sql(query)
        # create an array of names from the objects found
        supply_array = []
        mappings_objs.each do |m|
          supply_array.push(m.name)
        end
        return supply_array
      end
    end


    private

      # Create Supply, Hand, Discard decks for a given player
      def create_player_decks(player)
        if player
          player.create_supply(game_id: self.id, player_id: player.id , status: 'Supply')
          player.create_hand(game_id: self.id, player_id: player.id , status: 'Hand')
          player.create_discard(game_id: self.id, player_id: player.id , status: 'Discard')
          player.create_played(game_id: self.id, player_id: player.id , status: 'Played')
        end
      end

      # Create the initial cards in each players supply
      def create_player_cards(player)
        if player.supply
          7.times { player.supply.cards.create!( cardmapping_id: Cardmapping.get('Copper') ) }
          3.times { player.supply.cards.create!( cardmapping_id: Cardmapping.get( 'Estate') ) }
          # Testing purposes
          3.times { player.supply.cards.create!( cardmapping_id: Cardmapping.get( 'Bureaucrat' ) ) }
          player.supply.shuffle
        end
      end

      # Create Trash deck for the game
      def create_supply_decks
        Deck.create(game_id: id, player_id: -1, status: 'Trash')
      end
end
