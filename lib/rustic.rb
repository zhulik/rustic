# frozen_string_literal: true

require "async/process"

require "zeitwerk"

loader = Zeitwerk::Loader.for_gem

loader.setup

# Your code goes here...
class Rustic::Error < StandardError
end
