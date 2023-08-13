class AddCategoriyIdToKindlelists < ActiveRecord::Migration[7.0]
  def change
    add_reference :kindlelists, :category, foreign_key: true
    change_column :kindlelists, :category_id, :integer, null: false
  end
end
