class RemoveUniqueToBookinst2 < ActiveRecord::Migration[7.0]
  def change
    remove_index :booklists, column: :xid
  end
end
