# frozen_string_literal: true

class Rustic::Configs::Check
  include Rustic::HooksExt

  attr_reader :check_unused, :read_data_subset, :with_cache

  def initialize
    @check_unused = false
    @read_data_subset = nil
    @with_cache = false
  end

  def check_unused! = @check_unused = true
  def with_cache! = @with_cache = true

  def subset(percent)
    raise ArgumentError, "percent must be > 0 and <= 100. Given: #{percent}" if percent <= 0 || percent > 100

    @read_data_subset = percent
  end
end
