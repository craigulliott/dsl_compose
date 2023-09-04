# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments do
  let(:arguments) { DSLCompose::DSL::Arguments.new }

  describe :initialize do
    it "initializes a new Arguments without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments.new
      }.to_not raise_error
    end
  end

  describe :arguments do
    it "returns an empty array" do
      expect(arguments.arguments).to be_a(Array)
      expect(arguments.arguments.count).to eq(0)
    end

    describe "when Arguments have been added" do
      let(:new_argument) { arguments.add_argument :argument_name, true, false, :integer }
      let(:another_new_argument) { arguments.add_argument :another_argument_name, true, false, :integer }

      before(:each) do
        new_argument
        another_new_argument
      end

      it "returns an array of the expected Arguments" do
        expect(arguments.arguments).to be_a(Array)
        expect(arguments.arguments.count).to eq(2)
        expect(arguments.arguments.first.name).to eq(:argument_name)
        expect(arguments.arguments.first).to be(new_argument)
        expect(arguments.arguments.last.name).to eq(:another_argument_name)
        expect(arguments.arguments.last).to be(another_new_argument)
      end
    end
  end

  describe :any? do
    it "returns false" do
      expect(arguments.any?).to be false
    end

    describe "when Arguments have been added" do
      let(:new_argument) { arguments.add_argument :argument_name, true, false, :integer }

      before(:each) do
        new_argument
      end

      it "returns true" do
        expect(arguments.any?).to be true
      end
    end
  end

  describe :required_arguments do
    it "returns an empty array" do
      expect(arguments.required_arguments).to be_a(Array)
      expect(arguments.required_arguments.count).to eq(0)
    end

    describe "when required arguments have been added" do
      let(:required_argument) { arguments.add_argument :required_argument_name, true, false, :symbol }
      let(:another_required_argument) { arguments.add_argument :another_required_argument_name, true, false, :symbol }

      before(:each) do
        required_argument
        another_required_argument
      end

      it "returns an array of the required arguments" do
        expect(arguments.required_arguments).to be_a(Array)
        expect(arguments.required_arguments.count).to eq(2)
        expect(arguments.required_arguments.first.name).to eq(:required_argument_name)
        expect(arguments.required_arguments.first).to be(required_argument)
        expect(arguments.required_arguments.last.name).to eq(:another_required_argument_name)
        expect(arguments.required_arguments.last).to be(another_required_argument)
      end

      describe "when an optional argument has been added" do
        before(:each) do
          arguments.add_argument :argument_name, false, false, :symbol
        end

        it "returns only the required arguments" do
          expect(arguments.required_arguments).to be_a(Array)
          expect(arguments.required_arguments.count).to eq(2)
          expect(arguments.required_arguments.first.name).to eq(:required_argument_name)
          expect(arguments.required_arguments.first).to be(required_argument)
          expect(arguments.required_arguments.last.name).to eq(:another_required_argument_name)
          expect(arguments.required_arguments.last).to be(another_required_argument)
        end
      end
    end
  end

  describe :optional_arguments do
    it "returns an empty array" do
      expect(arguments.optional_arguments).to be_a(Array)
      expect(arguments.optional_arguments.count).to eq(0)
    end

    describe "when an required argument has been added" do
      before(:each) do
        arguments.add_argument :argument_name, true, false, :symbol
      end

      it "returns an empty array" do
        expect(arguments.optional_arguments).to be_a(Array)
        expect(arguments.optional_arguments.count).to eq(0)
      end

      describe "when optional arguments have been added" do
        let(:optional_argument) { arguments.add_argument :optional_argument_name, false, false, :symbol }
        let(:another_optional_argument) { arguments.add_argument :another_optional_argument_name, false, false, :symbol }

        before(:each) do
          optional_argument
          another_optional_argument
        end

        it "returns an array of only the optional arguments" do
          expect(arguments.optional_arguments).to be_a(Array)
          expect(arguments.optional_arguments.count).to eq(2)
          expect(arguments.optional_arguments.first.name).to eq(:optional_argument_name)
          expect(arguments.optional_arguments.first).to be(optional_argument)
          expect(arguments.optional_arguments.last.name).to eq(:another_optional_argument_name)
          expect(arguments.optional_arguments.last).to be(another_optional_argument)
        end
      end
    end
  end

  describe :argument do
    it "raises an error if the requested Argument does not exist" do
      expect {
        arguments.argument :an_argument_which_does_not_exist
      }.to raise_error(DSLCompose::DSL::Arguments::ArgumentDoesNotExistError)
    end

    describe "when aan Argument with the requested name has been added" do
      let(:new_argument) { arguments.add_argument :argument_name, true, false, :integer }

      before(:each) do
        new_argument
      end

      it "returns the expected Arguments" do
        expect(arguments.argument(:argument_name)).to be(new_argument)
      end
    end
  end

  describe :has_argument? do
    it "returns `false`" do
      expect(arguments.has_argument?(:a_argument_which_does_not_exist)).to eq(false)
    end

    describe "when aan Argument with the requested name has been added" do
      let(:new_argument) { arguments.add_argument :argument_name, true, false, :integer }

      before(:each) do
        new_argument
      end

      it "returns true" do
        expect(arguments.has_argument?(:argument_name)).to eq(true)
      end
    end
  end

  describe :add_argument do
    it "adds a new Argument without raising an error" do
      arguments.add_argument :argument_name, true, false, :integer
    end

    describe "when an Argument of the same name already exists" do
      before(:each) do
        arguments.add_argument :argument_name, true, false, :integer
      end

      it "raises an error" do
        expect {
          arguments.add_argument :argument_name, true, false, :integer
        }.to raise_error(DSLCompose::DSL::Arguments::ArgumentAlreadyExistsError)
      end
    end

    describe "when an optional Argument already exists" do
      before(:each) do
        arguments.add_argument :optional_argument_name, false, false, :integer
      end

      it "raises an error when adding a required Argument" do
        expect {
          arguments.add_argument :required_argument_name, true, false, :integer
        }.to raise_error(DSLCompose::DSL::Arguments::ArgumentOrderingError)
      end
    end
  end
end
