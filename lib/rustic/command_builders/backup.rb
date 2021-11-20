# frozen_string_literal: true

class Rustic::CommandBuilders::Backup
  def initialize(config)
    @config = config
  end

  def build
    config = @config.backup_config
    raise Rustic::CommandBuilder::MissingConfigError, "Command `backup` misses it's configuration" if config.nil?
    raise Rustic::CommandBuilder::MalformedConfigError, "Backup paths cannot be empty" if config.paths.empty?

    [
      "backup",
      config.one_fs ? "-x" : nil,
      *config.paths,
      *excludes
    ].compact
  end

  private

  def excludes = ["--exclude"].product(@config.backup_config.excluded_paths).flatten
end
