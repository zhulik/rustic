# frozen_string_literal: true

class Rustic::Application
  class UnknownCommandError < Rustic::Error; end

  def initialize(config)
    @config = config
  end

  def run(argv)
    command = argv.first || "backup"
    command_method = "command_#{command}"
    return send(command_method) if respond_to?(command_method, true)

    raise UnknownCommandError, "Unknown command #{command}"
  end

  private

  def command_snapshots
    command, env = Rustic::Script::CommandBuilder.new("snapshots", @config).build
    Rustic::Wrapper.new(command, env).run
  end

  def command_backup
    command, env = Rustic::Script::CommandBuilder.new("backup", @config).build
    Rustic::Wrapper.new(command, env).run
  end
end
