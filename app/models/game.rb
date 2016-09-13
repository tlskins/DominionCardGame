class Game < ActiveRecord::Base
  has_one :gamemanager, dependent: :destroy
  has_many :players, dependent: :destroy
  has_one :supply, class_name: "Deck", foreign_key: "game_id", dependent: :destroy
  has_one :trash, class_name: "Deck", foreign_key: "game_id", dependent: :destroy

    # Returns a string containing a list of all the users currently playing in this game
    def get_player_list
      players.map { |p| "Player " + p.turn_order.to_s + ": " + p.name + " | " }.join.to(-3)
    end

    # Returns a new game with new created players from the array of users passed to this method
    def Game.create_game_for(user_array)
      game = Game.create(status: "In Progress")
      # Randomize turn order
      user_array = user_array.shuffle
      turn_order_counter = 1
      # Create players for each user
      user_array.each do |u|
        player = Player.create(user_id: u.id, game_id: game.id, turn_order: turn_order_counter)
        turn_order_counter += 1
      end 
      # Create gamemanager
       manager = Gamemanager.create(game_id: game.id, phase: "Preaction", player_turn: game.players.find_by(turn_order: 1).id)
      # Returns game
      return game
    end

    # Updates the status of the game to "Finished" and cleans up any unnecessary data
    def end_game
      update_attributes(status: "Finished" )
    end
end
