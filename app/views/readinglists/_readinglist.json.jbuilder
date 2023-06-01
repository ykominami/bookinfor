json.extract! readinglist, :id, :register_date, :date, :title, :status, :shape, :isbn, :created_at, :updated_at
json.url readinglist_url(readinglist, format: :json)
