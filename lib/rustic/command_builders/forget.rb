# frozen_string_literal: true

class Rustic::CommandBuilders::Forget
  def initialize(config)
    @config = config
  end

  def build
    config = @config.forget_config
    raise Rustic::CommandBuilder::MissingConfigError, "Command `forget` misses it's configuration" if config.nil?

    [
      "forget",
      config.keep_last ? "--keep-last=#{config.keep_last}" : nil,
      config.keep_weekly ? "--keep-weekly=#{config.keep_weekly}" : nil,
      config.keep_monthly ? "--keep-monthly=#{config.keep_monthly}" : nil,
      config.prune ? "--prune" : nil
    ].compact
  end
end
