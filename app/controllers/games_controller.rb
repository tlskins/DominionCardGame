class GamesController < ApplicationController

  def index
    @games = User.find(params[:user_id]).games
  end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Dominion Card Game!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    Game.find(params[:id]).destroy
    flash[:success] = "Game deleted"
    redirect_to user_games_path
  end

end
