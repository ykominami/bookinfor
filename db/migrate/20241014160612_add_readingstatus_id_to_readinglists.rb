class AddReadingstatusIdToReadinglists < ActiveRecord::Migration[7.2]
  def change
    add_reference :readinglists, :readingstatus, foreign_key: true
    change_column :readinglists, :readingstatus_id, :integer, null: true
 end
end
