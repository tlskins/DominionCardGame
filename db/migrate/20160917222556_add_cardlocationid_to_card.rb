class AddCardlocationidToCard < ActiveRecord::Migration
  def change
    add_column :cards, :cardlocation_id, :integer
  end
end
