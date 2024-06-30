# frozen_string_literal: true

class Rustic::CommandBuilder
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

    config = add_command!

    [[@config.restic_path, *@args], @env_variables, config] # TODO: properly handle spaces in paths
  end

  private

  def add_repository_path! = @args.push("-r", @config.repository)

  def add_password!
    return @env_variables.merge!("RESTIC_PASSWORD" => @config.password) if @config.password
    return @env_variables.merge!("RESTIC_PASSWORD_FILE" => @config.password_file) if @config.password_file

    raise UnknownPasswordMethodError
  end

  def add_command!
    command_builder = Rustic::CommandBuilders.const_get(@command.capitalize).new(@config)
    @args.concat(command_builder.build)
    command_builder.config
  rescue NameError
    raise UnknownCommandError, "Unknown command #{@command}"
  end
end
