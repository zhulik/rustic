# frozen_string_literal: true

require_relative "lib/rustic/version"

Gem::Specification.new do |spec|
  spec.name          = "rustic"
  spec.version       = Rustic::VERSION
  spec.authors       = ["Gleb Sinyavskiy"]
  spec.email         = ["zhulik.gleb@gmail.com"]

  spec.summary       = "DSL for the restic backup tool."
  spec.description   = "DSL for the restic backup tool."
  spec.homepage      = "https://github.com/zhulik/rustic"
  spec.license       = "MIT"
  spec.required_ruby_version = [">= 3.0.0"] # rubocop:disable Gemspec/RequiredRubyVersion

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "async-process", "~> 1.3"
  spec.add_dependency "ptools", "~> 1.4"
  spec.add_dependency "zeitwerk", "~> 2.5"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }
end
