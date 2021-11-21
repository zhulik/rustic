# frozen_string_literal: true

class Rustic::Application
  class UnknownCommandError < Rustic::Error; end

  def initialize(config)
    @config = config
  end

  def run(argv)
    command = argv.first || "backup"
    Rustic::Evaluator.new(command, @config).evaluate
  end
end
