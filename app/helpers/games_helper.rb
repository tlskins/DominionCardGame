module GamesHelper

  def convert_game_players_array(game_players)
    #puts 'game_players = ' + game_players.to_s
    (game_players.nil? or game_players.blank?) ? @game_users = [] : 
      (game_players.include?(',') ? @game_users = User.find( game_players.to_s.split(',') ) : @game_users = [ User.find(game_players) ] )
    #puts '@game_users = !' + @game_users.to_s + '!'
  end

end

