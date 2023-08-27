class RemoveCategoryInCalibrelists < ActiveRecord::Migration[7.0]
  def change
    remove_column :calibrelists , :category
  end
end
