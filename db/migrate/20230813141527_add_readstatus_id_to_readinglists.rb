class AddReadstatusIdToReadinglists < ActiveRecord::Migration[7.0]
  def change
    add_reference :readinglists, :readstatus, foreign_key: true
    change_column :readinglists, :readstatus_id, :integer, null: false
  end
end
