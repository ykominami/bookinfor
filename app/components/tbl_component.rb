# frozen_string_literal: true

class TblComponent < ApplicationComponent
    def initialize(name:, header:, body: )
        @name = name
        @header = header
        @body = body
    end
end
