class AddShapeIdToReadinglists < ActiveRecord::Migration[7.0]
  def change
    add_reference :readinglists, :shape, foreign_key: true
  end
end
