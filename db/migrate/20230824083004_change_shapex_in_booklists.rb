class ChangeShapexInBooklists < ActiveRecord::Migration[7.0]
  def change
    rename_column :booklists, :shape, :shapex
  end
end
