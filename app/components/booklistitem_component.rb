# frozen_string_literal: true

# require 'forwardable'

class BooklistitemComponent < ApplicationComponent
  # extend Forwardable

  attr_reader :proxy

  # def_delegators("@helpers", "turbo_frame_tag", "turbo_strea_from", "notice", "edit_booklist_path")
  def initialize(booklist)
    @proxy = booklist
    # @helpers = helpers
  end
end
