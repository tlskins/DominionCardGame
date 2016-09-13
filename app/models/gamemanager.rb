class Gamemanager < ActiveRecord::Base
  belongs_to :game

  # End current phase and move on to next
  def next_phase
    if phase == 'Preaction'
      update_attributes(phase: "Action")
    elsif phase == 'Action'
      update_attributes(phase: "Buy")    
    elsif phase == 'Buy'
      next_turn
      update_attributes(phase: "Preaction")
    end
  end

  # End current user's turn and initiate next users turn
  def next_turn
    turn_sequence = game.players.find(player_turn).turn_order
    if turn_sequence == game.players.maximum(:turn_order)
      turn_sequence = 1
    else
      turn_sequence = turn_sequence + 1
    end
    update_attributes(player_turn: game.players.find_by(turn_order: turn_sequence).id)
  end

end
