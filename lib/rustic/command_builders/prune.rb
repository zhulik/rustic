# frozen_string_literal: true

class Rustic::CommandBuilders::Prune
  attr_reader :config

  def initialize(_config) = nil

  def build
    ["prune"]
  end
end
