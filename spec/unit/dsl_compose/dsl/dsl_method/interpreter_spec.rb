# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Interpreter do
  let(:dsl_method) { DSLCompose::DSL::DSLMethod.new :dsl_name, true, true }
  let(:interpreter) { DSLCompose::DSL::DSLMethod::Interpreter.new dsl_method }

  describe :initialize do
    it "initializes a new Interpreter without raising any errors" do
      expect {
        DSLCompose::DSL::DSLMethod::Interpreter.new dsl_method
      }.to_not raise_error
    end
  end

  describe "when interpreting a DSLMethod block which sets a description" do
    before(:each) do
      interpreter.instance_eval do
        description "This is a description"
      end
    end

    it "sets the description on the DSL" do
      expect(dsl_method.description).to eq "This is a description"
    end
  end

  describe "when interpreting a DSLMethod block which adds a required argument" do
    before(:each) do
      interpreter.instance_eval do
        requires :argument_name, :integer
      end
    end

    it "adds the expected Argument to the DSLMethod" do
      expect(dsl_method.arguments.argument(:argument_name)).to be_a DSLCompose::DSL::Arguments::Argument
      expect(dsl_method.arguments.argument(:argument_name).type).to be(:integer)
      expect(dsl_method.arguments.argument(:argument_name).required?).to be(true)
    end
  end

  describe "when interpreting a DSLMethod block which adds an optional argument" do
    before(:each) do
      interpreter.instance_eval do
        optional :argument_name, :integer
      end
    end

    it "adds the expected Argument to the DSL" do
      expect(dsl_method.arguments.argument(:argument_name)).to be_a DSLCompose::DSL::Arguments::Argument
      expect(dsl_method.arguments.argument(:argument_name).type).to be(:integer)
      expect(dsl_method.arguments.argument(:argument_name).optional?).to be(true)
    end
  end
end
