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
=begin
    def turbo_frame_tag(arg1, &block)
        helpers.turbo_frame_tag(arg1, block)
    end

    def turbo_stream_from(arg1)
        helpers.turbo_stream_from(arg1)
    end

    def notice
        helpers.notice
    end

    def edit_booklist_path
        helpers.edit_booklist_path
    end
=end
end
