# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Interpreter do
  let(:dummy_class) { Class.new }
  let(:dsl) { DSLCompose::DSL.new :dsl_name, dummy_class }
  let(:interpreter) { DSLCompose::DSL::Interpreter.new dsl }

  describe :initialize do
    it "initializes a new Interpreter without raising any errors" do
      DSLCompose::DSL::Interpreter.new dsl
    end
  end

  describe "when interpreting a DSLMethod block which sets a description" do
    before(:each) do
      interpreter.instance_eval do
        description "This is a description"
      end
    end

    it "sets the description on the DSL" do
      expect(dsl.description).to eq "This is a description"
    end
  end

  describe "when interpreting a DSLMethod block which adds a method" do
    before(:each) do
      interpreter.instance_eval do
        add_method :method_name
      end
    end

    it "adds the expected method to the DSL" do
      expect(dsl.dsl_method(:method_name)).to be_a DSLCompose::DSL::DSLMethod
      expect(dsl.dsl_method(:method_name).unique?).to be(false)
      expect(dsl.dsl_method(:method_name).required?).to be(false)
    end
  end

  describe "when interpreting a DSLMethod block which adds a unique method" do
    before(:each) do
      interpreter.instance_eval do
        add_unique_method :method_name
      end
    end

    it "adds the expected method to the DSL" do
      expect(dsl.dsl_method(:method_name)).to be_a DSLCompose::DSL::DSLMethod
      expect(dsl.dsl_method(:method_name).unique?).to be(true)
      expect(dsl.dsl_method(:method_name).required?).to be(false)
    end
  end

  describe "when interpreting a DSLMethod block which adds a required method" do
    before(:each) do
      interpreter.instance_eval do
        add_method :method_name, required: true
      end
    end

    it "adds the expected method to the DSL" do
      expect(dsl.dsl_method(:method_name)).to be_a DSLCompose::DSL::DSLMethod
      expect(dsl.dsl_method(:method_name).unique?).to be(false)
      expect(dsl.dsl_method(:method_name).required?).to be(true)
    end
  end

  describe "when interpreting a DSLMethod block which adds a required unique method" do
    before(:each) do
      interpreter.instance_eval do
        add_unique_method :method_name, required: true
      end
    end

    it "adds the expected method to the DSL" do
      expect(dsl.dsl_method(:method_name)).to be_a DSLCompose::DSL::DSLMethod
      expect(dsl.dsl_method(:method_name).unique?).to be(true)
      expect(dsl.dsl_method(:method_name).required?).to be(true)
    end
  end
end
