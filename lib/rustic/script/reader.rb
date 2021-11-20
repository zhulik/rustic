# frozen_string_literal: true

class Rustic::Script::Reader
  class FileReadingError < Rustic::Error; end
  class EvaluationError < Rustic::Error; end

  def initialize(file_path)
    @file_path = file_path
  end

  def read
    Rustic::Script::Config.new.tap do |config|
      config.instance_eval(script)
      Rustic::Script::Validator.new(config).validate!
    end
  rescue SyntaxError, NameError
    raise EvaluationError
  end

  private

  def script
    @script ||= File.read(@file_path)
  rescue StandardError
    raise FileReadingError
  end
end
