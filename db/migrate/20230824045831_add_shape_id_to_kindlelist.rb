class AddShapeIdToKindlelist < ActiveRecord::Migration[7.0]
  def change
    add_reference :kindlelists, :shape, foreign_key: true
  end
end
