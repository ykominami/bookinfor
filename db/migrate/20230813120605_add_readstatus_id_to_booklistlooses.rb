class AddReadstatusIdToBooklistlooses < ActiveRecord::Migration[7.0]
  def change
    add_reference :booklistlooses, :readstatus, foreign_key: true
    change_column :booklistlooses, :readstatus_id, :integer, null: false
  end
end
