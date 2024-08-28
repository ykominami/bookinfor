class AddReadstatusIdToCalibrelists < ActiveRecord::Migration[7.2]
  def change
    add_reference :calibrelists, :readstatus, foreign_key: true
    change_column :calibrelists, :readstatus_id, :integer, null: true
  end
end
