class AddReadstatusIdToBooklists < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklists, :readstatus, foreign_key: true
    change_column :booklists, :readstatus_id, :integer, null: false
  end
end
