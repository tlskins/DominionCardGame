module PlayersHelper

  # Returns the user corresponding to the remember token cookie.
  def current_player(game_id)
    if (user_id = session[:user_id])
      @current_player ||= Player.find_by(user_id: user_id, game_id: game_id)
    elsif (user_id = cookies.signed[:user_id])
      player = Player.find_by(user_id: user_id, game_id: game_id)
      if player
        @current_player = player
      end
    end
  end

  # Returns true if it is the current player's turn right now.
  def current_player_turn?(game_id)
    puts 'current_player(game_id).id = ' + current_player(game_id).id.to_s
    puts 'Game.find(game_id).gamemanager.player_turn = ' + Game.find(game_id).gamemanager.player_turn.to_s
    return (current_player(game_id).id == Game.find(game_id).gamemanager.player_turn)
  end

end
