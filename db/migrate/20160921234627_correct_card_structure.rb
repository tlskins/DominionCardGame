class CorrectCardStructure < ActiveRecord::Migration
  def change
    remove_column :cards, :card_mapping_id
    add_column :cards, :cardmapping_id, :integer
  end
end
