# frozen_string_literal: true

class BlComponent < ApplicationComponent
  attr_reader :proxy

  def initialize(name, klass, params, ind, ind_next, x)
    @name = name
    # @header = header
    # @body = body
    @klass = klass
    @params = params
    @search = @klass.ransack(@params[:q])
    @search.sorts = 'totalID desc' if @search.sorts.empty?
    @booklists = @search.result.page(@params[:page])
    @proxy = @booklists[0]
    @ind = ind
    @ind_next = ind_next + 1
    @x = x
  end
end
