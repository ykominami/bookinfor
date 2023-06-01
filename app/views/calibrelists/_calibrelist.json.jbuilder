json.extract! calibrelist, :id, :xid, :xxid, :isbn, :zid, :uuid, :comments, :size, :series, :series_index, :title, :title_sort, :tags, :library_name, :formats, :timestamp, :pubdate, :publisher, :authors, :author_sort, :languages, :created_at, :updated_at
json.url calibrelist_url(calibrelist, format: :json)
