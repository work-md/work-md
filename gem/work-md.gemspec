# frozen_string_literal: true

require_relative 'lib/work/md/version'

Gem::Specification.new do |spec|
  spec.name          = 'work-md'
  spec.version       = Work::Md::VERSION
  spec.authors       = ['Henrique Fernandez Teixeira']
  spec.email         = ['hriqueft@gmail.com']

  spec.summary       = 'Track your work activities, write annotations, recap what you did for a week, month or specific days... and much more!'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')
  spec.metadata['source_code_uri'] = 'https://github.com/work-md/work-md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir['{bin,lib}/**/*']

  spec.executables << 'work-md'
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'tty-box', '~> 0.7.0'
  spec.add_dependency 'tty-editor', '~> 0.7.0'
  spec.add_dependency 'tty-prompt', '~> 0.23.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
