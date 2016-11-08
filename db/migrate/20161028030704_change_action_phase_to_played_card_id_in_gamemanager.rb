class ChangeActionPhaseToPlayedCardIdInGamemanager < ActiveRecord::Migration
  def change
    add_column :gamemanagers, :played_card_id, :integer
    remove_column :gamemanagers, :action_phase, :string 
  end
end
