# frozen_string_literal: true

module Rustic::Script::HooksExt
  include Console

  def before(&block)
    return @before if block.nil?

    @before = block
  end

  def after(&block)
    return @after if block.nil?

    @after = block
  end
end
