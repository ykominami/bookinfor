class RemoveColShapexInBooklists < ActiveRecord::Migration[7.0]
  def change
    remove_column :booklists, :shapex
  end
end
