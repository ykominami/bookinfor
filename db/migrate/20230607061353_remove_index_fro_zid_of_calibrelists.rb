class RemoveIndexFroZidOfCalibrelists < ActiveRecord::Migration[7.0]
  def change
    remove_index :calibrelists, :zid, unique: false
  end
end
