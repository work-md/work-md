# frozen_string_literal: true

require_relative "lib/work_md/version"

Gem::Specification.new do |spec|
  spec.name          = "work_md"
  spec.version       = WorkMd::VERSION
  spec.authors       = ["Henrique Fernandez Teixeira"]
  spec.email         = ["hriqueft@gmail.com"]

  spec.summary       = "Track your work activities, write annotations, recap what you did for a week, month or specific days... and much more!"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.metadata["source_code_uri"] = "https://github.com/henriquefernandez/work_md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["{bin,lib}/**/*"]

  spec.executables << 'work_md'
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "tty-box"
  spec.add_dependency "tty-editor"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
