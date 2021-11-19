# frozen_string_literal: true

class Rustic::Application
  def initialize(argv)
    @argv = argv
  end

  def run
    case @argv.first
    when "script"
      config = Rustic::Script::Reader.new(@argv[1]).read
      Rustic::Script::Evaluator.new(config).evaluate

    else
      Rustic::Wrapper.new(["restic", *@argv]).run
    end
  end
end
