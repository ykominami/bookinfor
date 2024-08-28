class AddCategoryIdToKindlelists < ActiveRecord::Migration[7.2]
  def change
    add_reference :kindlelists, :category, foreign_key: true
    change_column :kindlelists, :category_id, :integer, null: true
  end
end
