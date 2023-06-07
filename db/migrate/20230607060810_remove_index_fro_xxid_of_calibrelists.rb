class RemoveIndexFroXxidOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    remove_index :calibrelists, :xxid, unique: false
  end
end
