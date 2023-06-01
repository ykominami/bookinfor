class AddColsToCalibres < ActiveRecord::Migration[7.0]
  def change
    add_column :calibrelists, :read_status, :integer
    add_column :calibrelists, :category, :string
  end
end
