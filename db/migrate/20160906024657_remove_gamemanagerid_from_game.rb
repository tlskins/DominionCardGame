class RemoveGamemanageridFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :gamemanager_id, :integer
  end
end
