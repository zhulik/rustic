# frozen_string_literal: true

class Rustic::CommandBuilders::Check
  def initialize(config)
    @config = config
  end

  def build
    config = @config.check_config
    raise Rustic::CommandBuilder::MissingConfigError, "Command `check` misses it's configuration" if config.nil?

    [
      "check",
      config.check_unused ? "--check-unused" : nil,
      read_data_subset(config),
      config.with_cache ? "--with-cache" : nil
    ].compact
  end

  def read_data_subset(config)
    return nil if config.read_data_subset.nil?
    return "--read-data" if config.read_data_subset == 100

    "--read-data-subset=#{config.read_data_subset}%"
  end
end
