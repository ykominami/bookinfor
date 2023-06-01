class CreateKindlelists < ActiveRecord::Migration[7.0]
  def change
    create_table :kindlelists do |t|
      t.string :asin, null: false
      t.string :title, null: false
      t.string :publisher, null: true
      t.string :author, null: false
      t.date :publish_date, null: true
      t.date :purchase_date, null: false

      t.timestamps
    end
  end
end
