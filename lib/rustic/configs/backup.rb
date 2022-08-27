# frozen_string_literal: true

class Rustic::Configs::Backup
  include Rustic::HooksExt

  attr_reader :paths, :excluded_paths, :one_fs, :compression_mode

  def initialize
    @paths = []
    @excluded_paths = []
    @one_fs = false
    @compression_mode = 'auto'
  end

  def backup(*paths)
    raise ArgumentError if paths.empty?

    @paths = paths
  end

  def exclude(*paths)
    raise ArgumentError if paths.empty?

    @excluded_paths = paths
  end

  def one_fs! = @one_fs = true
  
  def compression(value)
    @compression_mode = value
  end
end
