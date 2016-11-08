class AddSelectableToCards < ActiveRecord::Migration
  def change
    add_column :cards, :selectable, :boolean
  end
end
