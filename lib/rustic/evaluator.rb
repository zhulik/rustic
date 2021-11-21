# frozen_string_literal: true

class Rustic::Evaluator
  include Console

  def initialize(command, config)
    @command = command
    @config = config
  end

  def evaluate
    with_hooks(@config) do
      builder = Rustic::CommandBuilder.new(@command, @config)
      command, env, config = builder.build

      with_hooks(config) do
        Rustic::Wrapper.new(command, env).run
      end
    end
  rescue StandardError => e
    on_error(e)
    raise
  end

  def on_error(error) = @config.on_error&.call(error)
  def with_hooks(config, args = nil, &block) = Rustic::Hooks.new(config).with_hooks(args, &block)
end
