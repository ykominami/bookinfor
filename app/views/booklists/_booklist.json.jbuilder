json.extract! booklist, :id, :totalID, :xid, :purchase_date, :bookstore, :title, :asin, :read_status, :shape, :category, :created_at, :updated_at
json.url booklist_url(booklist, format: :json)
