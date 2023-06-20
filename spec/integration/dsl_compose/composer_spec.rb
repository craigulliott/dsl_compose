# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Composer do
  it "can be included into a class without raising any errors" do
    expect {
      Class.new do
        include DSLCompose::Composer
      end
    }.to_not raise_error
  end

  it "can be included into multiple different classes without raising any errors" do
    expect {
      Class.new do
        include DSLCompose::Composer
      end
      Class.new do
        include DSLCompose::Composer
      end
    }.to_not raise_error
  end

  it "raises an error if included into a class multiple times" do
    expect {
      Class.new do
        include DSLCompose::Composer
        include DSLCompose::Composer
      end
    }.to raise_error(DSLCompose::Composer::ComposerAlreadyInstalledError)
  end

  it "raises an error if included into a class which already has a define_dsl method" do
    expect {
      Class.new do
        def self.define_dsl
        end
        include DSLCompose::Composer
      end
    }.to raise_error(DSLCompose::Composer::ComposerAlreadyInstalledError)
  end

  it "raises an error if included into a class which already has a dsl_interpreter method" do
    expect {
      Class.new do
        def self.dsl_interpreter
        end
        include DSLCompose::Composer
      end
    }.to raise_error(DSLCompose::Composer::GetDSLExecutionResultsMethodAlreadyExistsError)
  end
end
