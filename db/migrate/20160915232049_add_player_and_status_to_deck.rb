class AddPlayerAndStatusToDeck < ActiveRecord::Migration
  def change
    add_column :decks, :player_id, :integer
    add_column :decks, :status, :string
  end
end
