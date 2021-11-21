# frozen_string_literal: true

class Rustic::CommandBuilders::Check
  attr_reader :config

  def initialize(config)
    @config = config.check_config
  end

  def build
    [
      "check",
      @config&.check_unused ? "--check-unused" : nil,
      read_data_subset,
      @config&.with_cache ? "--with-cache" : nil
    ].compact
  end

  private

  def read_data_subset
    return nil if @config.nil? || @config.read_data_subset.nil?
    return "--read-data" if @config.read_data_subset == 100

    "--read-data-subset=#{@config.read_data_subset}%"
  end
end
