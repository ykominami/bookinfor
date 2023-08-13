# frozen_string_literal: true

class LinkButtonComponent < ApplicationComponent
  SIZES = [
    :small,
    :medium,
    :large,
  ].freeze

  def initialize(label:, url:, size: :medium, view_context: nil)
    @label = label
    @url = url
    @size = size
    @view_context = view_context
  end

  def choose_size
    SIZES[@size] || :medium
  end

  # If not using the template
  # def call
  #   link_to @label, @url, class: choose_size
  # end

end
