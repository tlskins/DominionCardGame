class AddGamemanageridToGame < ActiveRecord::Migration
  def change
    add_column :games, :gamemanager_id, :integer
  end
end
