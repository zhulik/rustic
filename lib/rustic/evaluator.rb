# frozen_string_literal: true

class Rustic::Evaluator
  include Console

  def initialize(config) = @config = config

  def evaluate
    with_hooks(@config) do
      backup! unless @config.backup_config.nil?
    end
  rescue StandardError => e
    on_error(e)
    raise
  end

  def on_error(error) = @config.on_error&.call(error)

  def backup!
    with_hooks(@config.backup_config) do
      command, env = Rustic::CommandBuilder.new("backup", @config).build
      Rustic::Wrapper.new(command, env).run
    end
  end

  def with_hooks(config, args = nil, &block) = Rustic::Hooks.new(config).with_hooks(args, &block)
end
