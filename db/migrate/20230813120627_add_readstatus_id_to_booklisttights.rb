class AddReadstatusIdToBooklisttights < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklisttights, :readstatus, foreign_key: true
    change_column :booklisttights, :readstatus_id, :integer, null: false
  end
end
