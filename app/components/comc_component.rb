# frozen_string_literal: true

class ComcComponent < ApplicationComponent
  def initialize(target:, zid:, s:)
    @target = target
    @zid = zid
    @s = s
  end
end
