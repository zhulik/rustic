# frozen_string_literal: true

require "async/process"
require "ptools" # file File.which

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.setup

module Rustic
  class Error < StandardError; end
  class ValidationError < Error; end

  class << self
    def define(run: true, &block)
      Sync do
        config = Rustic::Script::Config.new
        config.instance_eval(&block)
        validate!(config)
        Rustic::Application.new(config).tap do |app|
          app.run(ARGV) if run
        end
      end
    end

    private

    def validate!(config)
      errors, warnings = Rustic::Script::Validator.new(config).validate
      warnings.each do |warning|
        # TODO: print warning
      end

      raise ValidationError, errors.join("\n") if errors.any?
    end
  end
end
