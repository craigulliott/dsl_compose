# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument do
  let(:integer_argument) { DSLCompose::DSL::DSLMethod::Argument.new :argument_name, true, :integer }
  let(:symbol_argument) { DSLCompose::DSL::DSLMethod::Argument.new :argument_name, true, :symbol }

  describe :initialize do
    it "initializes a new DSLMethod without raising any errors" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument.new :argument_name, true, :integer
      }.to_not raise_error
    end

    it "raises an error if using a string instead of a symbol for the DSLMethod name" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument.new "argument_name", true, :integer
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InvalidNameError)
    end

    it "raises an error if passing an unexpected type for the DSLMethod name" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument.new 123, true, :integer
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InvalidNameError)
    end
  end

  describe :set_description do
    it "sets a valid description without raising an error" do
      integer_argument.set_description "This is a description"
    end

    describe "when a description has already been set" do
      before(:each) do
        integer_argument.set_description "This is a description"
      end
      it "raises an error if you try and set the dsl description multiple times" do
        expect {
          integer_argument.set_description "This is a description"
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::DescriptionAlreadyExistsError)
      end
    end

    it "raises an error if you provide a symbol for the DSL description" do
      expect {
        integer_argument.set_description :invalid_description
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InvalidDescriptionError)
    end

    it "raises an error if you provide an unexpected type for the DSL description" do
      expect {
        integer_argument.set_description 123
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InvalidDescriptionError)
    end
  end

  describe :has_description do
    it "returns false if a description has not been set" do
      expect(integer_argument.has_description?).to eq(false)
    end

    describe "when a description has been set" do
      before(:each) do
        integer_argument.set_description "This is a description"
      end

      it "returns true if a description has been set" do
        expect(integer_argument.has_description?).to eq(true)
      end
    end
  end

  describe :required? do
    it "returns true for required Arguments" do
      expect(integer_argument.required?).to be true
    end

    let(:optional_integer_argument) { DSLCompose::DSL::DSLMethod::Argument.new :argument_name, false, :integer }

    it "returns false for required Arguments" do
      expect(optional_integer_argument.required?).to be false
    end
  end

  describe :optional? do
    it "returns false for required Arguments" do
      expect(integer_argument.optional?).to be false
    end

    let(:optional_integer_argument) { DSLCompose::DSL::DSLMethod::Argument.new :argument_name, false, :integer }

    it "returns true for required Arguments" do
      expect(optional_integer_argument.optional?).to be true
    end
  end

  describe :validate_greater_than do
    it "sets the validation without raising an error" do
      integer_argument.validate_greater_than 2
    end

    describe "when this validation has already been set" do
      before(:each) do
        integer_argument.validate_greater_than 2
      end

      it "raises an error" do
        expect {
          integer_argument.validate_greater_than 2
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_greater_than_or_equal_to do
    it "sets the validation without raising an error" do
      integer_argument.validate_greater_than_or_equal_to 2
    end

    describe "when this validation has already been set" do
      before(:each) do
        integer_argument.validate_greater_than_or_equal_to 2
      end

      it "raises an error" do
        expect {
          integer_argument.validate_greater_than_or_equal_to 2
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_less_than do
    it "sets the validation without raising an error" do
      integer_argument.validate_less_than 2
    end

    describe "when this validation has already been set" do
      before(:each) do
        integer_argument.validate_less_than 2
      end

      it "raises an error" do
        expect {
          integer_argument.validate_less_than 2
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_less_than_or_equal_to do
    it "sets the validation without raising an error" do
      integer_argument.validate_less_than_or_equal_to 2
    end

    describe "when this validation has already been set" do
      before(:each) do
        integer_argument.validate_less_than_or_equal_to 2
      end

      it "raises an error" do
        expect {
          integer_argument.validate_less_than_or_equal_to 2
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_format do
    it "sets the validation without raising an error" do
      symbol_argument.validate_format(/[a-z]/)
    end

    describe "when this validation has already been set" do
      before(:each) do
        symbol_argument.validate_format(/[a-z]/)
      end

      it "raises an error" do
        expect {
          symbol_argument.validate_format(/[a-z]/)
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_equal_to do
    it "sets the validation without raising an error" do
      symbol_argument.validate_equal_to(false)
    end

    describe "when this validation has already been set" do
      before(:each) do
        symbol_argument.validate_equal_to(false)
      end

      it "raises an error" do
        expect {
          symbol_argument.validate_equal_to(false)
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_in do
    it "sets the validation without raising an error" do
      symbol_argument.validate_in([1])
    end

    describe "when this validation has already been set" do
      before(:each) do
        symbol_argument.validate_in([1])
      end

      it "raises an error" do
        expect {
          symbol_argument.validate_in([1])
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_not_in do
    it "sets the validation without raising an error" do
      symbol_argument.validate_not_in([1])
    end

    describe "when this validation has already been set" do
      before(:each) do
        symbol_argument.validate_not_in([1])
      end

      it "raises an error" do
        expect {
          symbol_argument.validate_not_in([1])
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end

  describe :validate_length do
    it "sets the validation without raising an error" do
      symbol_argument.validate_length(is: 5)
    end

    describe "when this validation has already been set" do
      before(:each) do
        symbol_argument.validate_length(is: 5)
      end

      it "raises an error" do
        expect {
          symbol_argument.validate_length(is: 5)
        }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
      end
    end
  end
end
