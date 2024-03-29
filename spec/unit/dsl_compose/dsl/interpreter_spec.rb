# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Interpreter do
  before(:each) do
    create_class :TestClass
  end

  let(:dsl) { DSLCompose::DSL.new :dsl_name, TestClass }
  let(:interpreter) { DSLCompose::DSL::Interpreter.new dsl }

  describe :initialize do
    it "initializes a new Interpreter without raising any errors" do
      expect {
        DSLCompose::DSL::Interpreter.new dsl
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
      expect(dsl.description).to eq "This is a description"
    end
  end

  describe "when interpreting a DSLMethod block which sets a namespace" do
    before(:each) do
      interpreter.instance_eval do
        namespace :valid_namespace
      end
    end

    it "sets the namespace on the DSL" do
      expect(dsl.namespace).to eq :valid_namespace
    end
  end

  describe "when interpreting a DSLMethod block which sets a title" do
    before(:each) do
      interpreter.instance_eval do
        title "DSL Title"
      end
    end

    it "sets the title on the DSL" do
      expect(dsl.title).to eq "DSL Title"
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

  describe "when interpreting a DSL block which adds a required argument" do
    before(:each) do
      interpreter.instance_eval do
        requires :argument_name, :integer
      end
    end

    it "adds the expected Argument to the DSL" do
      expect(dsl.arguments.argument(:argument_name)).to be_a DSLCompose::DSL::Arguments::Argument
      expect(dsl.arguments.argument(:argument_name).type).to be(:integer)
      expect(dsl.arguments.argument(:argument_name).required?).to be(true)
    end
  end

  describe "when interpreting a DSL block which adds an optional argument" do
    before(:each) do
      interpreter.instance_eval do
        optional :argument_name, :integer
      end
    end

    it "adds the expected Argument to the DSL" do
      expect(dsl.arguments.argument(:argument_name)).to be_a DSLCompose::DSL::Arguments::Argument
      expect(dsl.arguments.argument(:argument_name).type).to be(:integer)
      expect(dsl.arguments.argument(:argument_name).optional?).to be(true)
    end
  end

  describe "when interpreting a DSL block which adds an optional argument via shared configuration" do
    before(:each) do
      DSLCompose::SharedConfiguration.add :shared_conf do
        optional :argument_name, :integer
      end

      interpreter.instance_eval do
        import_shared :shared_conf
      end
    end

    it "adds the expected Argument to the DSL" do
      expect(dsl.arguments.argument(:argument_name)).to be_a DSLCompose::DSL::Arguments::Argument
      expect(dsl.arguments.argument(:argument_name).type).to be(:integer)
      expect(dsl.arguments.argument(:argument_name).optional?).to be(true)
    end
  end
end
