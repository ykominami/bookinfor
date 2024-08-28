class AddCategoryIdToCalibrelists < ActiveRecord::Migration[7.2]
  def change
    add_reference :calibrelists, :category, foreign_key: true
    change_column :calibrelists, :category_id, :integer, null: true
  end
end
