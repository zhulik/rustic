# frozen_string_literal: true

class Rustic::Script::BackupConfig
  include Rustic::Script::HooksExt

  attr_reader :paths, :excluded_paths, :one_fs

  def initialize
    @paths = []
    @excluded_paths = []
    @one_fs = false
  end

  def backup(*paths)
    raise ArgumentError if paths.empty?

    @paths = paths
  end

  def exclude(*paths)
    raise ArgumentError if paths.empty?

    @excluded_paths = paths
  end

  def one_fs!
    @one_fs = true
  end
end
