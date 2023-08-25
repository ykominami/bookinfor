class RemoveColReadStatusAndCategoryFromBooklist < ActiveRecord::Migration[7.0]
  def change
    remove_column :booklists, :read_status
    remove_column :booklists, :category
  end
end
