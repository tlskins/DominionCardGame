class RemoveCardidDeckidIndexUniqConst < ActiveRecord::Migration
  def change
    remove_index :cardlocations, [:card_id, :deck_id]
  end
end
