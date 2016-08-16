class AddIndexToCardmapping < ActiveRecord::Migration
  def change
    add_index :cardmappings, :name, unique: true
  end
end
