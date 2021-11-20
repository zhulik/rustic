# frozen_string_literal: true

class Rustic::Application
  class UnknownCommandError < Rustic::Error; end

  def initialize(config)
    @config = config
  end

  def run(argv)
    command = argv.first || "backup"
    command, env = Rustic::CommandBuilder.new(command, @config).build
    Rustic::Wrapper.new(command, env).run
  end
end
