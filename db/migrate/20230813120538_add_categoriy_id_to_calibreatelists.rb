class AddCategoriyIdToCalibreatelists < ActiveRecord::Migration[7.0]
  def change
    add_reference :calibrelists, :category, foreign_key: true
    change_column :calibrelists, :category_id, :integer, null: false
  end
end
