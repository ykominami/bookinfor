class CreateBookstores < ActiveRecord::Migration[7.2]
  def change
    create_table :bookstores do |t|
      t.string :name

      t.timestamps
    end
  end
end
