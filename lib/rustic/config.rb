# frozen_string_literal: true

class Rustic::Config
  include Rustic::HooksExt

  attr_reader :restic_path, :backup_config, :check_config, :strict_validation

  def initialize
    @restic_path = "restic"
    @strict_validation = false
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
    @backup_config ||= Rustic::Configs::Backup.new
    @backup_config.instance_eval(&block)
  end

  def check(&block)
    @check_config ||= Rustic::Configs::Check.new
    @check_config.instance_eval(&block) unless block.nil?
  end

  def strict_validation! = @strict_validation = true
end
