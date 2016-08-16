class RemoveColumnsFromDeck < ActiveRecord::Migration
  def change
    remove_column :decks, :order
    remove_column :decks, :card_id
  end
end
