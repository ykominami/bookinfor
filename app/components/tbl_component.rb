# frozen_string_literal: true

class TblComponent < ApplicationComponent
  def initialize(name:, header:, body:, view_context: nil)
    @name = name
    @header = header
    @body = body
    @view_context = view_context
  end
end
