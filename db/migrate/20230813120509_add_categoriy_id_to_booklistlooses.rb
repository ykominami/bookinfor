class AddCategoriyIdToBooklistlooses < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklistlooses, :category, foreign_key: true
    change_column :booklistlooses, :category_id, :integer, null: false
  end
end
