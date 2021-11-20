# frozen_string_literal: true

require "async/process"

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.setup

# Your code goes here...
class Rustic::Error < StandardError
end

module Rustic
  class << self
    def define(run: true, &block)
      Sync do
        config = Rustic::Script::Config.new
        config.instance_eval(&block)
        Rustic::Script::Validator.new(config).validate!
        app = Rustic::Application.new(config)
        return app unless run

        app.run(ARGV) if run
      end
    end
  end
end
