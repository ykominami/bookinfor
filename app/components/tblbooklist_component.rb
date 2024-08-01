# frozen_string_literal: true

class TblbooklistComponent < ApplicationComponent
  def initialize(name:, header:, body:)
    @name = name
    @header = header
    @body = body
  end
end
