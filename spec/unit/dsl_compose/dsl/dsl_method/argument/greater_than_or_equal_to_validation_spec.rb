# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation do
  describe :initialize do
    it "initializes a new GreaterThanOrEqualToValidation without raising any errors" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation.new 100
      }.to_not raise_error
    end

    it "raises an error if initializing the GreaterThanOrEqualToValidation with a string instead of a number" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation.new "100"
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation::InvalidValueError)
    end

    describe :validate do
      let(:greater_than_or_equal_to_validation) { DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation.new 100 }

      it "does not raise an error if tested with a value larger than the originally provided value" do
        expect {
          greater_than_or_equal_to_validation.validate!(101)
        }.to_not raise_error
      end

      it "does not raise an error if tested with a value equal to the originally provided value" do
        expect {
          greater_than_or_equal_to_validation.validate!(100)
        }.to_not raise_error
      end

      it "raises an error if tested with a value greater than the originally provided value" do
        expect {
          greater_than_or_equal_to_validation.validate!(99)
        }.to raise_error DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation::ValidationFailedError
      end
    end
  end
end
