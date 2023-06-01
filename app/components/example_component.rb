# frozen_string_literal: true

class ExampleComponent < ApplicationComponent
  def initialize(title:, array:)
  end
  def at(index)
    @array[index]
  end
end
