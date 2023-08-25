class AddShapeIdToBooklist < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklists, :shape, foreign_key: true
  end
end
