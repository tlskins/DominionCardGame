class RemoveCardidIndexUniqConst < ActiveRecord::Migration
  def change
    remove_index :cardlocations, :card_id
  end
end
