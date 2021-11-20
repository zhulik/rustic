# frozen_string_literal: true

class Rustic::CommandBuilders::Snapshots
  def initialize(config)
    @config = config
  end

  def build
    ["snapshots"]
  end
end
