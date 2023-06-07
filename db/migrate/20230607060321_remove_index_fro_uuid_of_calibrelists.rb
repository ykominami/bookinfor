class RemoveIndexFroUuidOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    remove_index :calibrelists, :uuid, unique: false
  end
end
