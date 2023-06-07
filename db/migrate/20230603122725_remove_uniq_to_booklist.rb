class RemoveUniqToBooklist < ActiveRecord::Migration[7.0]
  def change
    change_column :booklistlooses, :xid,  :integer, null: true
  end
end
