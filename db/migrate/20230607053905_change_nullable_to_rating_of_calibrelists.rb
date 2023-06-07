class ChangeNullableToRatingOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    change_column :calibrelists, :rating, :string, null: true
  end
end
