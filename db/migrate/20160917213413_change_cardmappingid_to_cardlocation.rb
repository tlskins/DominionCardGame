class ChangeCardmappingidToCardlocation < ActiveRecord::Migration
  def change
    add_column :cardlocations, :cardmapping_id, :integer
    remove_column :cards, :cardmapping_id, :integer

  end
end
