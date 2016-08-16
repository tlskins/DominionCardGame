class CreateCardlocations < ActiveRecord::Migration
  def change
    create_table :cardlocations do |t|
      t.integer :card_id
      t.integer :deck_id

      t.timestamps null: false
    end
    add_index :cardlocations, :card_id, unique:true
    add_index :cardlocations, :deck_id
    add_index :cardlocations, [:card_id, :deck_id], unique: true
  end
end
