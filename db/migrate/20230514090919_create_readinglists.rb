class CreateReadinglists < ActiveRecord::Migration[7.0]
  def change
    create_table :readinglists do |t|
      t.date :register_date, null: false
      t.date :date, null: false
      t.string :title, null: false
      t.string :isbn, null: true

      t.timestamps
    end
  end
end
