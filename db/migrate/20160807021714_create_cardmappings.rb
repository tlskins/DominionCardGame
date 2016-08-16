class CreateCardmappings < ActiveRecord::Migration
  def change
    create_table :cardmappings do |t|
      t.string :name
      t.string :text
      t.boolean :is_action
      t.boolean :is_attack
      t.boolean :is_action
      t.boolean :is_reaction
      t.boolean :is_treasure
      t.boolean :is_victory
      t.integer :treasure_amount
      t.integer :victory_points
      t.integer :cost

      t.timestamps null: false
    end
  end
end
