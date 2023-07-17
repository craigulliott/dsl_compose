# frozen_string_literal: true

require "byebug"
require "class_spec_helper"

require "dsl_compose"

CLASS_SPEC_HELPER = ClassSpecHelper.new

def create_class fully_qualified_class_name, base_class = nil, &block
  CLASS_SPEC_HELPER.create_class fully_qualified_class_name, base_class, &block
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # make class_spec_helper conveniently accessable within your test suite
  config.add_setting :class_spec_helper
  config.class_spec_helper = CLASS_SPEC_HELPER

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Run the garbage collector before each test. This is nessessary because
  # we use `ObjectSpace` to determine class hieracy, and deleted classes will
  # still exist in ObjectSpace until the garbage collector runs
  config.before(:each) do
    ObjectSpace.garbage_collect
  end

  # after each spec, clear all the DSLs so that we can start fresh each time
  config.after(:each) do
    DSLCompose::DSLs.reset
  end

  # after each spec, clear all the shared configuration so that we can start fresh each time
  config.after(:each) do
    DSLCompose::SharedConfiguration.clear
  end

  # destroy these dyanmically created classes after each test
  config.after(:each) do
    CLASS_SPEC_HELPER.remove_all_dynamically_created_classes
  end
end
