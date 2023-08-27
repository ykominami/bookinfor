class RemoveReadstatusInCalibrelists < ActiveRecord::Migration[7.0]
  def change
    remove_column :calibrelists , :read_status
  end
end
