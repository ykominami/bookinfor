class ChangeCategoryInReadingNullTrue < ActiveRecord::Migration[7.0]
  def up
    change_column :readinglists, :category_id, :integer, null: true
  end

  def down
    change_column :readinglists, :category_id, :integer, null: false
  end
end
