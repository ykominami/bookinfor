class ChangeCategoryInReading < ActiveRecord::Migration[7.0]
  def change
    change_column :readinglists, :category_id, :integer, null: true
  end
end
