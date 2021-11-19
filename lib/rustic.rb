# frozen_string_literal: true

require "async/process"

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.inflector.inflect(
  "cli" => "CLI"
)

loader.setup

# Your code goes here...
class Rustic::Error < StandardError
end
