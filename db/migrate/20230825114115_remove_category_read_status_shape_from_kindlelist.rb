class RemoveCategoryReadStatusShapeFromKindlelist < ActiveRecord::Migration[7.0]
  def change
    remove_column :kindlelists, :category
    remove_column :kindlelists, :read_status
  end
end
