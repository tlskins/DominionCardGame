class AddCardVariablesToGamemanagers < ActiveRecord::Migration
  def change
    add_column :gamemanagers, :selection_id, :integer
    add_column :gamemanagers, :prompt, :string
    add_column :gamemanagers, :value, :integer
  end
end
