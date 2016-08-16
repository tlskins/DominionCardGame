class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.integer :card_id
      t.integer :order

      t.timestamps null: false
    end
  end
end
