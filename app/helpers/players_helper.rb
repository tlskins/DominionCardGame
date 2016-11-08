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

end
