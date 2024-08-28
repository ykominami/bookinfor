class AddShapeIdToBooklists < ActiveRecord::Migration[7.2]
  def change
    add_reference :booklists, :shape, foreign_key: true
    change_column :booklists, :shape_id, :integer, null: true
  end
end
