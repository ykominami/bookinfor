class AddReadstatusIdToReadinglists < ActiveRecord::Migration[7.2]
  def change
    add_reference :readinglists, :readstatus, foreign_key: true
    change_column :readinglists, :readstatus_id, :integer, null: true
  end
end
