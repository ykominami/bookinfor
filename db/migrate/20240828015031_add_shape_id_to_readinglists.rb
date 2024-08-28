class AddShapeIdToReadinglists < ActiveRecord::Migration[7.2]
  def change
    add_reference :readinglists, :shape, foreign_key: true
    change_column :readinglists, :shape_id, :integer, null: true
  end
end
