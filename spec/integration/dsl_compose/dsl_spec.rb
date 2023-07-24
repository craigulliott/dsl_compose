# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL do
  it "successfully creates a new DSL which has no configuration block" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    expect(DSLCompose::DSLs.class_dsl(TestClass, :dsl_name)).to be_a(DSLCompose::DSL)
  end

  it "successfully evaluates a DSL which has no configuration block" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    TestClass.dsl_name do
    end

    expect(TestClass.dsls.to_h(:dsl_name).count).to eq(1)
  end

  it "returns the expected execution object when evaluating a DSL" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    TestClass.dsl_name do
    end

    expect(TestClass.dsl_name).to be_a(DSLCompose::Interpreter::Execution)
  end

  it "allows calling the same DSL twice for a class, because DSL definitions can be extended/combined" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name
      define_dsl :dsl_name
    end

    expect(DSLCompose::DSLs.class_dsl(TestClass, :dsl_name)).to be_a(DSLCompose::DSL)
  end

  it "successfully evaluates a DSL twice" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    TestClass.dsl_name do
    end

    TestClass.dsl_name do
    end

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {},
          method_calls: {}
        }
      }
    )
  end

  describe "the DSL name" do
    it "raises an error if using a name which is already present on a class as a method" do
      expect {
        create_class :TestClass do
          include DSLCompose::Composer
          define_dsl :name
        end
      }.to raise_error(DSLCompose::Composer::MethodAlreadyExistsWithThisDSLNameError)
    end

    it "raises an error if using a string instead of a symbol for the DSL name" do
      expect {
        create_class :TestClass do
          include DSLCompose::Composer
          define_dsl "dsl_name"
        end
      }.to raise_error(DSLCompose::DSL::InvalidNameError)
    end

    it "raises an error if passing an unexpected type for the DSL name" do
      expect {
        create_class :TestClass do
          include DSLCompose::Composer
          define_dsl 123
        end
      }.to raise_error(DSLCompose::DSL::InvalidNameError)
    end
  end
end
