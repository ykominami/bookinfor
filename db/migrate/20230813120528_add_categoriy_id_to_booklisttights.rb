class AddCategoriyIdToBooklisttights < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklisttights, :category, foreign_key: true
    change_column :booklisttights, :category_id, :integer, null: false
  end
end
