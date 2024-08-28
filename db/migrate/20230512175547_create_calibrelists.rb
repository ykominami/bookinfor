class CreateCalibrelists < ActiveRecord::Migration[7.0]
  def change
    create_table :calibrelists do |t|
      t.integer :xid, null: false, unique: true 
      t.string :xxid, null: false, unique: true 
      t.string :isbn, null: true

      t.integer :zid, null: false, unique: true 
      t.string :uuid, null: false, unique: true 
      t.string :comments, null: true 
      t.integer :size , null: true
      t.string :series, null: true 
      t.integer :series_index , null: false
      t.string :title, null: false 
      t.string :title_sort , null: false
      t.string :tags , null: true
      t.string :library_name , null: false
      t.string :formats, null: false 
      t.timestamp :timestamp, null: false 
      t.timestamp :pubdate, null: false 
      t.string :publisher, null: false 
      t.string :authors, null: false 
      t.string :author_sort, null: false
      t.string :languages, null: false 
      t.string :rating, null: false 
      t.string :identifiers, null: false

      # t.integer :readstatus_id, null: false
      # t.integer :category_id, null: false

    end
  end
end
