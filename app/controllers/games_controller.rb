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
    @game_players = nil
    @game_users = []
    @avail_users = User.where('id != ?', current_user.id)
    @creator_id = current_user.id
  end

  def addplayer
    (params[:game_players].nil? or params[:game_players].blank?) ? @game_players = params[:player].to_s : @game_players = params[:game_players].to_s + ',' + params[:player].to_s
    convert_game_players_array(@game_players)
    @avail_users = User.where.not(id: (@game_players + ',' + current_user.id.to_s).to_s.split(','))
    @creator_id = current_user.id
    render '/games/new'
  end

  def create
    @game_players = params[:game_players].to_s
    convert_game_players_array(@game_players)
    @game = Game.create_game_for(current_user.id, @game_users)
    if @game.valid?
      @game.initialize_player_cards
      flash[:success] = "New Game Started!"
      redirect_to @game
    else
      render '/games/new'
    end
  end

  def destroy
    if current_user.id  == Game.find(params[:id]).players.find_by(turn_order: 1).user_id
      Game.find(params[:id]).destroy
      flash[:success] = "Game deleted"
    end
    redirect_to user_games_path(current_user.id)
  end

end
