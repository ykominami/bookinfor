class CreateAbcs < ActiveRecord::Migration[7.0]
  def change
    create_table :abcs do |t|
      t.integer :zid, null: false, unique: true
      t.string :s, null: false, unique: true

      t.timestamps
    end
  end
end
