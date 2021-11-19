# frozen_string_literal: true

class Rustic::Wrapper
  include Console

  class ExitStatusError < Rustic::Error; end
  class ExecutionError < Rustic::Error; end

  def initialize(argv, env_variables = {})
    @argv = argv
    @env_variables = env_variables
  end

  def run
    logger.info(self, "Executing:", @argv)
    begin
      status = Async::Process.spawn(@env_variables, *@argv)
    rescue StandardError
      raise ExecutionError
    end
    return if status.exitstatus.zero? # TODO: check #success?

    raise ExitStatusError, "Exit status is not 0: #{status.exitstatus}"
  end
end
