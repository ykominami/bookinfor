class RemoveColIndexInReading < ActiveRecord::Migration[7.0]
  def change
    remove_index :readinglists, :categories_id
    remove_column :readinglists, :categories_id
  end
end
