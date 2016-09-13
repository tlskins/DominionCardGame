class AddGameIdToGamemanager < ActiveRecord::Migration
  def change
    add_column :gamemanagers, :game_id, :integer
  end
end
