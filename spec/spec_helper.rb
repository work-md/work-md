# frozen_string_literal: true

require "./spec/helpers"
require "byebug"
require "fileutils"
require "work_md"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers

  config.before(:each) do
    allow(WorkMd::Config).to receive(:work_dir).and_return(test_work_dir)
    allow(WorkMd::Config).to(
      receive(:translations).and_return(WorkMd::Config::TRANSLATIONS['en'])
    )
  end
end
