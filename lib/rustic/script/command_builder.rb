# frozen_string_literal: true

class Rustic::Script::CommandBuilder
  class UnknownPasswordMethodError < Rustic::Error; end
  class UnknownCommandError < Rustic::Error; end
  class MissingConfigError < Rustic::Error; end
  class MalformedConfigError < Rustic::Error; end

  def initialize(command, config)
    @command = command
    @config = config
  end

  def build
    @args = []
    @env_variables = {}

    add_repository_path!
    add_password!

    add_command!

    [[@config.restic_path, *@args], @env_variables] # TODO: properly handle spaces in paths
  end

  private

  def add_repository_path! = @args += ["-r", @config.repository]

  def add_password!
    return @env_variables.merge!("RESTIC_PASSWORD" => @config.password) if @config.password
    return @env_variables.merge!("RESTIC_PASSWORD_FILE" => @config.password_file) if @config.password_file

    raise UnknownPasswordMethodError
  end

  def add_command!
    command_method = "command_#{@command}"
    return @args.concat(send(command_method)) if respond_to?(command_method, true)

    raise UnknownCommandError, "Unknown command #{@command}"
  end

  def excludes = ["--exclude"].product(@config.backup_config.excluded_paths).flatten

  def command_snapshots = ["snapshots"]

  def command_backup
    config = @config.backup_config
    raise MissingConfigError, "Command `backup` misses it's configuration" if config.nil?
    raise MalformedConfigError, "Backup paths cannot be empty" if config.paths.empty?

    ["backup", config.one_fs ? "-x" : nil, *config.paths, *excludes].compact
  end
end
