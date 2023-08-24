class ChangeShapeToReadinglistsWith < ActiveRecord::Migration[7.0]
  def change
    rename_column :readinglists, :shape, :shapex
  end
end
