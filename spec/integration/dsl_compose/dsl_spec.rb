# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL do
  it "successfully creates a new DSL which has no configuration block" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    expect(DSLCompose::DSLs.class_dsl(klass, :dsl_name)).to be_a(DSLCompose::DSL)
  end

  it "successfully evaluates a DSL which has no configuration block" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    klass.dsl_name do
    end

    expect(klass.dsl_interpreter.to_h(klass).count).to eq(1)
  end

  it "allows calling the same DSL twice for a class, because DSL definitions can be extended/combined" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name
      define_dsl :dsl_name
    end

    expect(DSLCompose::DSLs.class_dsl(klass, :dsl_name)).to be_a(DSLCompose::DSL)
  end

  it "successfully evaluates a DSL twice" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end

    klass.dsl_name do
    end

    klass.dsl_name do
    end

    expect(klass.dsl_interpreter.to_h(klass)).to eql(
      {
        dsl_name: {}
      }
    )
  end

  describe "the DSL name" do
    it "raises an error if using a name which is already present on a class as a method" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl :name
        end
      }.to raise_error(DSLCompose::Composer::MethodAlreadyExistsWithThisDSLNameError)
    end

    it "raises an error if using a string instead of a symbol for the DSL name" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl "dsl_name"
        end
      }.to raise_error(DSLCompose::DSL::InvalidNameError)
    end

    it "raises an error if passing an unexpected type for the DSL name" do
      expect {
        Class.new do
          include DSLCompose::Composer
          define_dsl 123
        end
      }.to raise_error(DSLCompose::DSL::InvalidNameError)
    end
  end
end
