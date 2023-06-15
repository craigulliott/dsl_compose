# frozen_string_literal: true

require "byebug"
require "dsl_compose"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # before each spec, clear all the DSLs so that we can start fresh each time
  config.before(:each) do
    DSLCompose::DSLs.reset
  end
end
