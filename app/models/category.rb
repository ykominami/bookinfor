class Category < ApplicationRecord
  has_many :kindlelists
  has_many :booklists
  has_many :booklistlooses
  has_many :booklisttights
  has_many :readinglists
end
