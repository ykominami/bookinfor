class AddReadstatusIdToKindlelists < ActiveRecord::Migration[7.0]
  def change
    add_reference :kindlelists, :readstatus, foreign_key: true
    change_column :kindlelists, :readstatus_id, :integer, null: false
  end
end
