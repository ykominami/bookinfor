# frozen_string_literal: true

require 'ransack'
require 'ransack/search'

class BooklistComponent < ApplicationComponent
  include BooklistsHelper
  # include Ransack
  # include Ransack::Helpers
  include Ransack::Helpers::FormHelper
  include Turbo::FramesHelper

  def initialize(name, klass, params)
    @name = name
    # @header = header
    # @body = body
    @klass = klass
    @params = params

    # @booklists = Booklist.all
    # @booklists = Booklistloose.where("read_status != ?", 4).where("read_status != ?", 2).order(shape: :DESC).order("read_status").order("category").order("purchase_date").order("title")
    # @booklists = Booklistloose.where("read_status != ?", 4).where("read_status != ?", 2).order("bookstore").order(shape: :DESC).order("read_status").order("category").order("purchase_date").order("title")
    # value = "アマゾン"
    # value = "%アマゾ%"
    # value = "アマゾン(Kindle)"
    # value = "アマゾン(Kindle unlimited)"
    # value = "アマゾンマーケットプレイス"
    # value = "アマゾン経由"
    # bklists = @klass.where("read_status != ?", 4)
    # bklists_1 = bklists.where("read_status != ?", 2)
    #    bklists_2 = bklists_1.where("bookstore = ?", value)
    #    bklists_2 = bklists_1.where("bookstore like ?", value)
    #    bklists_3 = bklists_2.order(shape: :DESC)
    #    bklists_3 = bklists_1.order(shape: :DESC)
    # bklists_3 = bklists_1.where("shape = ?" , 2)
    # bklists_4 = bklists_3.order("read_status")
    # bklists_5 = bklists_4.order("category")
    # bklists_6 = bklists_5.order("purchase_date")
    # bklists_7 = bklists_6.order("title")

    # @booklists = bklists_7
    # @booklists = Booklistloose.where("read_status != ?", 4).where("read_status != ?", 2).where("bookstore = ?", value).order(shape: :DESC).order("read_status").order("category").order("purchase_date").order("title")
    @search = @klass.ransack(@params[:q])
    @search.sorts = 'totalID desc' if @search.sorts.empty?
    @booklists = @search.result.page(@params[:page])

    # @booklist = Booklistx.new("Booklist", @booklists)
  end
end
