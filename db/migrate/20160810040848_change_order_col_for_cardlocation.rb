class ChangeOrderColForCardlocation < ActiveRecord::Migration
  def change
    rename_column :cardlocations, :order, :card_order
  end
end
