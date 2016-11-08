class GamesController < ApplicationController
  include GamesHelper

  def index
    @games = User.find(params[:user_id]).games
  end

  def show
    @game = Game.find(params[:id])
    @player = current_player(@game.id)
    @supply_cards = @game.generate_supply_cards_hash
  end

  def new
    @avail_users = User.where('id != ?', current_user.id)
    @game_players = current_user.id
    convert_game_players_array(@game_players)
  end

  def addplayer
    params[:game_players].nil? ? @game_players = current_user.id : @game_players = params[:game_players].to_s + ',' + params[:player].to_s
    convert_game_players_array(@game_players)
    @avail_users = User.where.not(id: @game_players.to_s.split(','))
    render '/games/new'
  end

  def create
    @game_players = params[:game_players].to_s
    convert_game_players_array(@game_players)
    @game = Game.create_game_for(@game_users)
    if @game.valid?
      @game.initialize_player_cards
      flash[:success] = "New Game Started!"
      redirect_to @game
    else
      render '/games/new'
    end
  end

  def destroy
    Game.find(params[:id]).destroy
    flash[:success] = "Game deleted"
    redirect_to user_games_path(current_user.id)
  end

end
