# frozen_string_literal: true

class Rustic::Script::Config
  include Rustic::Script::HooksExt

  attr_reader :restic_path, :backup_config

  def initialize
    @restic_path = "restic"
  end

  def restic(path)
    @restic_path = path
  end

  def repository(path = nil)
    return @path if path.nil?

    @path = path
  end

  def password(password = nil)
    return @password if password.nil?

    @password = password
  end

  def password_file(password_file = nil)
    return @password_file if password_file.nil?

    @password_file = password_file
  end

  def on_error(&block)
    return @on_error if block.nil?

    @on_error = block
  end

  def backup(&block)
    @backup_config ||= Rustic::Script::BackupConfig.new
    @backup_config.instance_eval(&block)
  end
end
