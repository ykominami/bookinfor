class RemoveColumnFromReadinglists < ActiveRecord::Migration[7.0]
  def change
    remove_column :readinglists, :category_id
  end
end
