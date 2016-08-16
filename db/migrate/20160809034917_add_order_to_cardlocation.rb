class AddOrderToCardlocation < ActiveRecord::Migration
  def change
    add_column :cardlocations, :order, :integer
  end
end
