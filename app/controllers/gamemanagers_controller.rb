class GamemanagersController < ApplicationController

  def play_card
    gamemanager = Gamemanager.find(params[:gamemanager_id])
    card = Card.find(params[:card_id])
    gamemanager.play_card(card)

    @game = Game.find(params[:id])
    @player = current_player(@game.id)
    @supply_cards = @game.generate_supply_cards_hash

    respond_to do |format|
      format.html { redirect_to game }
      format.js 
    end
  end

  def play_card_action
    game = Game.find(params[:id])
    gamemanager = Gamemanager.find(params[:gamemanager_id])
    @selectable_supply_array = gamemanager.play_card_action(eval(params[:action_hash]))

    @game = Game.find(params[:id])
    @player = current_player(@game.id)
    @supply_cards = @game.generate_supply_cards_hash
    #@selectable_supply_array = @selectable_supply_array unless @selectable_supply_array.nil?
    if @selectable_supply_array
      puts 'array is not null = ' + @selectable_supply_array.to_s
    else
      puts 'array is null!'
    end

    respond_to do |format|
      format.html { redirect_to game }
      format.js 
    end
  end

  def end_card_action
    game = Game.find(params[:id])
    gamemanager = Gamemanager.find(params[:gamemanager_id])
    gamemanager.end_card_action_phase
    gamemanager.play_card_action(params[:action_hash])

    @game = Game.find(params[:id])
    @player = current_player(@game.id)
    @supply_cards = @game.generate_supply_cards_hash

    respond_to do |format|
      format.html { redirect_to game }
      format.js
    end
  end

  def buy_card
    game = Game.find(params[:id])
    gamemanager = Gamemanager.find(params[:gamemanager_id])
    gamemanager.buy_card(params[:card_name])

    @game = Game.find(params[:id])
    @player = current_player(@game.id)
    @supply_cards = @game.generate_supply_cards_hash

    respond_to do |format|
      format.html { redirect_to game }
      format.js
    end
  end

  def next_phase
    game = Game.find(params[:id])
    gamemanager = Gamemanager.find(params[:gamemanager_id])
    gamemanager.next_phase

    @game = Game.find(params[:id])
    @player = current_player(@game.id)
    @supply_cards = @game.generate_supply_cards_hash

    respond_to do |format|
      format.html { redirect_to game }
      format.js
    end
  end

end
