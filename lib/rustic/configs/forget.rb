# frozen_string_literal: true

class Rustic::Configs::Forget
  include Rustic::HooksExt

  attr_reader :keep_last, :keep_weekly, :keep_monthly, :prune

  def initialize
    @prune = false
  end

  def keep(last: nil, weekly: nil, monthly: nil)
    raise ArgumentError, "keep options must be provided" if [last, weekly, monthly].all?(&:nil?)

    @keep_last = last
    @keep_weekly = weekly
    @keep_monthly = monthly
  end

  def prune! = @prune = true
end
