# frozen_string_literal: true

class Rustic::Hooks
  def initialize(config)
    @before = config&.before
    @after = config&.after
  end

  def with_hooks(arg = nil)
    raise ArgumentError unless block_given?

    @before&.call(arg)
    yield
    @after&.call(arg)
  end
end
