# frozen_string_literal: true

class Rustic::CommandBuilders::Backup
  attr_reader :config

  def initialize(config)
    @config = config.backup_config
  end

  def build
    raise Rustic::CommandBuilder::MissingConfigError, "Command `backup` misses it's configuration" if @config.nil?
    raise Rustic::CommandBuilder::MalformedConfigError, "Backup paths cannot be empty" if @config.paths.empty?

    [
      "--compression",
      @config.compression_mode,
      "backup",
      @config.one_fs ? "-x" : nil,
      *@config.paths,
      *excludes
    ].compact
  end

  private

  def excludes = ["--exclude"].product(@config.excluded_paths).flatten
end
