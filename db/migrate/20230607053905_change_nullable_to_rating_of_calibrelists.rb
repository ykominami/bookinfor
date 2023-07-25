class ChangeNullableToRatingOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    change_column :kindlelists, :publisher, :string, null: true
    change_column :kindlelists, :publish_date, :string, null: true
  end
end
