class RemoveColInReadings < ActiveRecord::Migration[7.0]
  def change
    remove_column :readinglists, :shapex
  end
end
