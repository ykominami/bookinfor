class ChangeCategoryInReadingNullTrue3 < ActiveRecord::Migration[7.0]
  def up
    add_reference :readinglists, :categories, foreign_key: true
    change_column :readinglists, :category_id, :integer, null: true
  end

  def down
    add_reference :readinglists, :categories, foreign_key: true
    change_column :readinglists, :category_id, :integer, null: false
  end
end
