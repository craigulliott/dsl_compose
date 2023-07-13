# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Composer do
  it "can be included into a class without raising any errors" do
    expect {
      create_class :TestClass do
        include DSLCompose::Composer
      end
    }.to_not raise_error
  end

  it "can be included into multiple different classes without raising any errors" do
    expect {
      create_class :TestClassA do
        include DSLCompose::Composer
      end
      create_class :TestClassB do
        include DSLCompose::Composer
      end
    }.to_not raise_error
  end

  it "raises an error if included into a class multiple times" do
    expect {
      create_class :TestClass do
        include DSLCompose::Composer
        include DSLCompose::Composer
      end
    }.to raise_error(DSLCompose::Composer::ComposerAlreadyInstalledError)
  end

  it "raises an error if included into a class which already has a define_dsl method" do
    expect {
      create_class :TestClass do
        def self.define_dsl
        end
        include DSLCompose::Composer
      end
    }.to raise_error(DSLCompose::Composer::ComposerAlreadyInstalledError)
  end

  it "raises an error if included into a class which already has a dsls method" do
    expect {
      create_class :TestClass do
        def self.dsls
        end
        include DSLCompose::Composer
      end
    }.to raise_error(DSLCompose::Composer::GetDSLExecutionResultsMethodAlreadyExistsError)
  end
end
