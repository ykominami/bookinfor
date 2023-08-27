class ChangeColInCalibrelists < ActiveRecord::Migration[7.0]
  def change
    change_column :calibrelists, :zid, :integer, null: true
    change_column :calibrelists, :size, :integer, null: true
    change_column :calibrelists, :series_index, :integer, null: true

    change_column :calibrelists, :xxid, :string, null: true
    change_column :calibrelists, :isbn, :string, null: true
    change_column :calibrelists, :uuid, :string, null: true
    change_column :calibrelists, :comments, :string, null: true
    change_column :calibrelists, :series, :string, null: true
    change_column :calibrelists, :title_sort, :string, null: true
    change_column :calibrelists, :tags, :string, null: true
    change_column :calibrelists, :library_name, :string, null: true
    change_column :calibrelists, :formats, :string, null: true
    change_column :calibrelists, :publisher, :string, null: true
    change_column :calibrelists, :authors, :string, null: true
    change_column :calibrelists, :author_sort, :string, null: true
    change_column :calibrelists, :languages, :string, null: true
    change_column :calibrelists, :rating, :string, null: true
    change_column :calibrelists, :identifiers, :string, null: true
    change_column :calibrelists, :pubdate, :datetime, null: true
  end
end
