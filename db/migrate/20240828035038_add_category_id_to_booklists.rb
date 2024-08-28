class AddCategoryIdToBooklists < ActiveRecord::Migration[7.2]
  def change
    add_reference :booklists, :category, foreign_key: true
    change_column :booklists, :category_id, :integer, null: true
  end
end
