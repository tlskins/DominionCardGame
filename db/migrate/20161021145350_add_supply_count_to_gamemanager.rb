class AddSupplyCountToGamemanager < ActiveRecord::Migration
  def change
    add_column :gamemanagers, :supply_count, :text
  end
end
