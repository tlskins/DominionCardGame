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

    # Returns a new game with new created players from the array of users passed to this method
    def Game.create_game_for(user_array)
      game = Game.create(status: "In Progress")
      # Randomize turn order
      user_array = user_array.shuffle
      turn_order_counter = 1
      # Create players for each user
      user_array.each do |u|
        game.players.create(user_id: u.id, turn_order: turn_order_counter)
        turn_order_counter += 1
      end 
      # Create gamemanager
      game.create_gamemanager(phase: "Preaction", player_turn: game.players.find_by(turn_order: 1).id)
      # Returns game
      return game
    end

    # Creates decks for supply and players and intial cards for all the players
    def initialize_player_cards
      create_supply_decks
      players.each do |p|
        create_player_decks(p)
        create_player_cards(p)
      end
    end

    private

      # Create Supply, Hand, Discard decks for a given player
      def create_player_decks(player)
        if player
          player.create_supply(game_id: self.id, player_id: player.id , status: 'Supply')
          player.create_hand(game_id: self.id, player_id: player.id , status: 'Hand')
          player.create_discard(game_id: self.id, player_id: player.id , status: 'Discard')
        end
      end

      # Create the initial cards in each players supply
      def create_player_cards(player)
        if player.supply
          7.times { 
            copper_card = player.supply.cards.create
            copper_loc = Cardlocation.create(cardmapping_id: Cardmapping.find_by(name: 'Copper').id, card_id: copper_card.id) 
            copper_card.cardlocation_id=copper_loc.id
            copper_card.save
          }
          3.times { 
            estate_card = player.supply.cards.create
            estate_loc = Cardlocation.create(cardmapping_id: Cardmapping.find_by(name: 'Estate').id, card_id: estate_card.id)
            estate_card.cardlocation_id=estate_loc.id
            estate_card.save
          }
          player.supply.shuffle
        end
      end

      # Create Trash deck for the game
      def create_supply_decks
        Deck.create(game_id: id, player_id: -1, status: 'Trash')
      end
end
