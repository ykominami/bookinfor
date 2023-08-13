class AddCategoryIdToReadinglists < ActiveRecord::Migration[7.0]
  def change
    add_reference :readinglists, :category, foreign_key: true
    change_column :readinglists, :category_id, :integer, null: false
  end
end
