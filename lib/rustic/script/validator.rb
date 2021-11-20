# frozen_string_literal: true

class Rustic::Script::Validator
  def initialize(config)
    @config = config
  end

  def validate
    @errors = []
    @warnings = []
    validate_config!
    validate_backup_config!
    [@errors, @warnings]
  end

  private

  def validate_config! # rubocop:disable Metrics/AbcSize
    if @config.restic_path.nil? || File.which(@config.restic_path).nil?
      error!("restic path is miconfigured: '#{@config.restic_path.inspect}'")
    end
    error!("repository is not configured") if @config.repository.nil?
    error!("password is not configured") if @config.password.nil? && @config.password_file.nil?
    warning!("backup is not configured") if @config.backup_config.nil?
  end

  def validate_backup_config! # rubocop:disable Metrics/AbcSize
    config = @config.backup_config
    return if config.nil?

    return unless @config.strict_validation

    error!("backup paths must be alphabetically sorted") if config.paths != config.paths.sort
    error!("backup paths contain duplicates") if config.paths != config.paths.uniq
    error!("excluded paths must be alphabetically sorted") if config.excluded_paths != config.excluded_paths.sort
    error!("excluded paths contain duplicates") if config.excluded_paths != config.excluded_paths.uniq
  end

  def error!(message) = @errors << message

  def warning!(message) = @warnings << message
end
