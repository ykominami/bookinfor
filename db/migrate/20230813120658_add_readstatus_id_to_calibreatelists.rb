class AddReadstatusIdToCalibreatelists < ActiveRecord::Migration[7.0]
  def change
    add_reference :calibrelists, :readstatus, foreign_key: true
    change_column :calibrelists, :readstatus_id, :integer, null: false
  end
end
