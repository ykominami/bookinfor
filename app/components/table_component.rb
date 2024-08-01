# frozen_string_literal: true

class TableComponent < ApplicationComponent
  def initialize(name:, total_score:)
    @name = name
    @total_score = total_score
    @header = total_score.header
  end
end
