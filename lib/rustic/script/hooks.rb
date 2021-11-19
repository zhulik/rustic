# frozen_string_literal: true

class Rustic::Script::Hooks
  def initialize(config)
    @before = config.before
    @after = config.after
  end

  def with_hooks(arg = nil)
    raise ArgumentError unless block_given?

    @before&.call(arg)
    yield
    @after&.call(arg) # TODO: do not call the after block if an exception was raised
  end
end
