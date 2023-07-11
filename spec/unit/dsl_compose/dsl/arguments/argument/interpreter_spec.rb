# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::Interpreter do
  let(:integer_argument) { DSLCompose::DSL::Arguments::Argument.new :integer_argument_name, true, :integer }
  let(:integer_argument_interpreter) { DSLCompose::DSL::Arguments::Argument::Interpreter.new integer_argument }
  let(:symbol_argument) { DSLCompose::DSL::Arguments::Argument.new :symbol_argument_name, true, :symbol }
  let(:symbol_argument_interpreter) { DSLCompose::DSL::Arguments::Argument::Interpreter.new symbol_argument }

  describe :initialize do
    it "initializes a new Interpreter without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::Interpreter.new integer_argument
      }.to_not raise_error
    end
  end

  describe "when interpreting an Argument block which sets a description" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        description "This is a description"
      end
    end

    it "sets the description on the Argument" do
      expect(integer_argument.description).to eq "This is a description"
    end
  end

  describe "when interpreting an Argument block which adds a greater_than_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_greater_than 10
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.greater_than_validation).to be_a DSLCompose::DSL::Arguments::Argument::GreaterThanValidation
    end
  end

  describe "when interpreting an Argument block which adds a greater_than_or_equal_to_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_greater_than_or_equal_to 10
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.greater_than_or_equal_to_validation).to be_a DSLCompose::DSL::Arguments::Argument::GreaterThanOrEqualToValidation
    end
  end

  describe "when interpreting an Argument block which adds a less_than_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_less_than 10
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.less_than_validation).to be_a DSLCompose::DSL::Arguments::Argument::LessThanValidation
    end
  end

  describe "when interpreting an Argument block which adds a less_than_or_equal_to_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_less_than_or_equal_to 10
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.less_than_or_equal_to_validation).to be_a DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation
    end
  end

  describe "when interpreting an Argument block which adds a format_validation" do
    before(:each) do
      symbol_argument_interpreter.instance_eval do
        validate_format(/[a-z]/)
      end
    end

    it "adds the expected validation to the Argument" do
      expect(symbol_argument.format_validation).to be_a DSLCompose::DSL::Arguments::Argument::FormatValidation
    end
  end

  describe "when interpreting an Argument block which adds a equal_to_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_equal_to 10
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.equal_to_validation).to be_a DSLCompose::DSL::Arguments::Argument::EqualToValidation
    end
  end

  describe "when interpreting an Argument block which adds a in_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_in [10]
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.in_validation).to be_a DSLCompose::DSL::Arguments::Argument::InValidation
    end
  end

  describe "when interpreting an Argument block which adds a not_in_validation" do
    before(:each) do
      integer_argument_interpreter.instance_eval do
        validate_not_in [10]
      end
    end

    it "adds the expected validation to the Argument" do
      expect(integer_argument.not_in_validation).to be_a DSLCompose::DSL::Arguments::Argument::NotInValidation
    end
  end

  describe "when interpreting an Argument block which adds an end_with_validation" do
    before(:each) do
      symbol_argument_interpreter.instance_eval do
        validate_end_with "_foo"
      end
    end

    it "adds the expected validation to the Argument" do
      expect(symbol_argument.end_with_validation).to be_a DSLCompose::DSL::Arguments::Argument::EndWithValidation
    end
  end

  describe "when interpreting an Argument block which adds a not_end_with_validation" do
    before(:each) do
      symbol_argument_interpreter.instance_eval do
        validate_not_end_with "_foo"
      end
    end

    it "adds the expected validation to the Argument" do
      expect(symbol_argument.not_end_with_validation).to be_a DSLCompose::DSL::Arguments::Argument::NotEndWithValidation
    end
  end

  describe "when interpreting an Argument block which adds a start_with_validation" do
    before(:each) do
      symbol_argument_interpreter.instance_eval do
        validate_start_with "foo_"
      end
    end

    it "adds the expected validation to the Argument" do
      expect(symbol_argument.start_with_validation).to be_a DSLCompose::DSL::Arguments::Argument::StartWithValidation
    end
  end

  describe "when interpreting an Argument block which adds a not_start_with_validation" do
    before(:each) do
      symbol_argument_interpreter.instance_eval do
        validate_not_start_with "foo_"
      end
    end

    it "adds the expected validation to the Argument" do
      expect(symbol_argument.not_start_with_validation).to be_a DSLCompose::DSL::Arguments::Argument::NotStartWithValidation
    end
  end

  describe "when interpreting an Argument block which adds a length_validation" do
    before(:each) do
      symbol_argument_interpreter.instance_eval do
        validate_length is: 10
      end
    end

    it "adds the expected validation to the Argument" do
      expect(symbol_argument.length_validation).to be_a DSLCompose::DSL::Arguments::Argument::LengthValidation
    end
  end
end
