class AddCategoriyIdToBooklists < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklists, :category, foreign_key: true
    change_column :booklists, :category_id, :integer, null: false
  end
end
