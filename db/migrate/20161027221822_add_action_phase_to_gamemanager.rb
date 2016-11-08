class AddActionPhaseToGamemanager < ActiveRecord::Migration
  def change
    add_column :gamemanagers, :action_phase, :string
  end
end
