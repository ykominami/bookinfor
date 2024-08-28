class AddShapeIdToKindlelists < ActiveRecord::Migration[7.2]
  def change
    add_reference :kindlelists, :shape, foreign_key: true
    change_column :kindlelists, :shape_id, :integer, null: true
  end
end
