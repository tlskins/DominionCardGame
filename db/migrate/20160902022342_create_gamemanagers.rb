class CreateGamemanagers < ActiveRecord::Migration
  def change
    create_table :gamemanagers do |t|
      t.integer :player_turn
      t.integer :actions
      t.integer :treasure
      t.integer :buys
      t.string :phase

      t.timestamps null: false
    end
  end
end
