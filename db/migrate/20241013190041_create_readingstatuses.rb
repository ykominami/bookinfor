class CreateReadingstatuses < ActiveRecord::Migration[7.2]
  def change
    create_table :readingstatuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
