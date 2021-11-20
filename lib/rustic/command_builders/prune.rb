# frozen_string_literal: true

class Rustic::CommandBuilders::Prune
  def initialize(config)
    @config = config
  end

  def build
    ["prune"]
  end
end
