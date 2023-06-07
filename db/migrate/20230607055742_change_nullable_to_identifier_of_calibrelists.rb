class ChangeNullableToIdentifierOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    change_column :calibrelists, :identifiers, :string, null: true
  end
end
