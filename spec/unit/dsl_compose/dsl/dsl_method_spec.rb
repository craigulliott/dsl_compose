# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod do
  let(:dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, true, true }

  describe :initialize do
    it "initializes a new DSLMethod without raising any errors" do
      DSLCompose::DSL::DSLMethod.new :method_name, true, true
    end

    it "raises an error if using a string instead of a symbol for the DSLMethod name" do
      expect {
        DSLCompose::DSL::DSLMethod.new "method_name", true, true
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidNameError)
    end

    it "raises an error if passing an unexpected type for the DSLMethod name" do
      expect {
        DSLCompose::DSL::DSLMethod.new 123, true, true
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidNameError)
    end
  end

  describe :set_description do
    it "sets a valid description without raising an error" do
      dsl_method.set_description "This is a description"
    end

    describe "when a description has already been set" do
      before(:each) do
        dsl_method.set_description "This is a description"
      end
      it "raises an error if you try and set the dsl description multiple times" do
        expect {
          dsl_method.set_description "This is a description"
        }.to raise_error(DSLCompose::DSL::DSLMethod::DescriptionAlreadyExistsError)
      end
    end

    it "raises an error if you provide a symbol for the DSL description" do
      expect {
        dsl_method.set_description :invalid_description
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
    end

    it "raises an error if you provide an unexpected type for the DSL description" do
      expect {
        dsl_method.set_description 123
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
    end
  end

  describe :has_description do
    it "returns false if a description has not been set" do
      expect(dsl_method.has_description?).to eq(false)
    end

    describe "when a description has been set" do
      before(:each) do
        dsl_method.set_description "This is a description"
      end

      it "returns true if a description has been set" do
        expect(dsl_method.has_description?).to eq(true)
      end
    end
  end

  describe :arguments do
    it "returns an empty array" do
      expect(dsl_method.arguments).to be_a(Array)
      expect(dsl_method.arguments.count).to eq(0)
    end

    describe "when Arguments have been added" do
      let(:new_argument) { dsl_method.add_argument :argument_name, true, :integer }
      let(:another_new_argument) { dsl_method.add_argument :another_argument_name, true, :integer }

      before(:each) do
        new_argument
        another_new_argument
      end

      it "returns an array of the expected Arguments" do
        expect(dsl_method.arguments).to be_a(Array)
        expect(dsl_method.arguments.count).to eq(2)
        expect(dsl_method.arguments.first.name).to eq(:argument_name)
        expect(dsl_method.arguments.first).to be(new_argument)
        expect(dsl_method.arguments.last.name).to eq(:another_argument_name)
        expect(dsl_method.arguments.last).to be(another_new_argument)
      end
    end
  end

  describe :required_arguments do
    it "returns an empty array" do
      expect(dsl_method.required_arguments).to be_a(Array)
      expect(dsl_method.required_arguments.count).to eq(0)
    end

    describe "when required arguments have been added" do
      let(:required_argument) { dsl_method.add_argument :required_argument_name, true, :symbol }
      let(:another_required_argument) { dsl_method.add_argument :another_required_argument_name, true, :symbol }

      before(:each) do
        required_argument
        another_required_argument
      end

      it "returns an array of the required arguments" do
        expect(dsl_method.required_arguments).to be_a(Array)
        expect(dsl_method.required_arguments.count).to eq(2)
        expect(dsl_method.required_arguments.first.name).to eq(:required_argument_name)
        expect(dsl_method.required_arguments.first).to be(required_argument)
        expect(dsl_method.required_arguments.last.name).to eq(:another_required_argument_name)
        expect(dsl_method.required_arguments.last).to be(another_required_argument)
      end

      describe "when an optional argument has been added" do
        before(:each) do
          dsl_method.add_argument :argument_name, false, :symbol
        end

        it "returns only the required arguments" do
          expect(dsl_method.required_arguments).to be_a(Array)
          expect(dsl_method.required_arguments.count).to eq(2)
          expect(dsl_method.required_arguments.first.name).to eq(:required_argument_name)
          expect(dsl_method.required_arguments.first).to be(required_argument)
          expect(dsl_method.required_arguments.last.name).to eq(:another_required_argument_name)
          expect(dsl_method.required_arguments.last).to be(another_required_argument)
        end
      end
    end
  end

  describe :optional_arguments do
    it "returns an empty array" do
      expect(dsl_method.optional_arguments).to be_a(Array)
      expect(dsl_method.optional_arguments.count).to eq(0)
    end

    describe "when an required argument has been added" do
      before(:each) do
        dsl_method.add_argument :argument_name, true, :symbol
      end

      it "returns an empty array" do
        expect(dsl_method.optional_arguments).to be_a(Array)
        expect(dsl_method.optional_arguments.count).to eq(0)
      end

      describe "when optional arguments have been added" do
        let(:optional_argument) { dsl_method.add_argument :optional_argument_name, false, :symbol }
        let(:another_optional_argument) { dsl_method.add_argument :another_optional_argument_name, false, :symbol }

        before(:each) do
          optional_argument
          another_optional_argument
        end

        it "returns an array of only the optional arguments" do
          expect(dsl_method.optional_arguments).to be_a(Array)
          expect(dsl_method.optional_arguments.count).to eq(2)
          expect(dsl_method.optional_arguments.first.name).to eq(:optional_argument_name)
          expect(dsl_method.optional_arguments.first).to be(optional_argument)
          expect(dsl_method.optional_arguments.last.name).to eq(:another_optional_argument_name)
          expect(dsl_method.optional_arguments.last).to be(another_optional_argument)
        end
      end
    end
  end

  describe :argument do
    it "raises an error if the requested Argument does not exist" do
      expect {
        dsl_method.argument :an_argument_which_does_not_exist
      }.to raise_error(DSLCompose::DSL::DSLMethod::ArgumentDoesNotExistError)
    end

    describe "when aan Argument with the requested name has been added" do
      let(:new_argument) { dsl_method.add_argument :argument_name, true, :integer }

      before(:each) do
        new_argument
      end

      it "returns the expected DSLMethod" do
        expect(dsl_method.argument(:argument_name)).to be(new_argument)
      end
    end
  end

  describe :has_argument? do
    it "returns `false`" do
      expect(dsl_method.has_argument?(:a_argument_which_does_not_exist)).to eq(false)
    end

    describe "when aan Argument with the requested name has been added" do
      let(:new_argument) { dsl_method.add_argument :argument_name, true, :integer }

      before(:each) do
        new_argument
      end

      it "returns true" do
        expect(dsl_method.has_argument?(:argument_name)).to eq(true)
      end
    end
  end

  describe :unique? do
    it "returns true for unique DSLMethods" do
      expect(dsl_method.unique?).to be true
    end

    let(:nonunique_dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, false, true }

    it "returns false for unique DSLMethods" do
      expect(nonunique_dsl_method.unique?).to be false
    end
  end

  describe :required? do
    it "returns true for required DSLMethods" do
      expect(dsl_method.required?).to be true
    end

    let(:optional_dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, true, false }

    it "returns false for required DSLMethods" do
      expect(optional_dsl_method.required?).to be false
    end
  end

  describe :optional? do
    it "returns false for required DSLMethods" do
      expect(dsl_method.optional?).to be false
    end

    let(:optional_dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, true, false }

    it "returns true for required DSLMethods" do
      expect(optional_dsl_method.optional?).to be true
    end
  end

  describe :add_argument do
    it "adds a new Argument without raising an error" do
      dsl_method.add_argument :argument_name, true, :integer
    end

    describe "when an Argument of the same name already exists" do
      before(:each) do
        dsl_method.add_argument :argument_name, true, :integer
      end

      it "raises an error" do
        expect {
          dsl_method.add_argument :argument_name, true, :integer
        }.to raise_error(DSLCompose::DSL::DSLMethod::ArgumentAlreadyExistsError)
      end
    end

    describe "when an optional Argument already exists" do
      before(:each) do
        dsl_method.add_argument :optional_argument_name, false, :integer
      end

      it "raises an error when adding a required Argument" do
        expect {
          dsl_method.add_argument :required_argument_name, true, :integer
        }.to raise_error(DSLCompose::DSL::DSLMethod::ArgumentOrderingError)
      end
    end
  end
end
