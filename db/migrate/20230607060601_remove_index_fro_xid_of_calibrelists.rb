class RemoveIndexFroXidOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    remove_index :calibrelists, :xid, unique: false
  end
end
