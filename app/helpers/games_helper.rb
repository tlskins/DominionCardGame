module GamesHelper

  def convert_game_players_array(game_players)
    unless game_players.nil?
      @game_users = User.find(game_players.to_s.split(','))
    end
  end

end

