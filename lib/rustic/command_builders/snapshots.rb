# frozen_string_literal: true

class Rustic::CommandBuilders::Snapshots
  attr_reader :config

  def initialize(_config) = nil

  def build
    ["snapshots"]
  end
end
