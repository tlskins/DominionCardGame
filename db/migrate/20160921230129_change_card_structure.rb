class ChangeCardStructure < ActiveRecord::Migration
  def change
    remove_column :cards, :cardlocation_id
    add_column :cards, :deck_id, :integer
    add_column :cards, :card_mapping_id, :integer
    add_column :cards, :card_order, :integer
  end
end
