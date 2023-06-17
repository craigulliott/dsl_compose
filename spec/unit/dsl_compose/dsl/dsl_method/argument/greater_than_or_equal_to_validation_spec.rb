# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation do
  describe :initialize do
    it "initializes a new GreaterThanOrEqualToValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation.new 100
    end

    it "raises an error if initializing the GreaterThanOrEqualToValidation with a string instead of a number" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation.new "100"
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation::InvalidValueError)
    end

    describe :validate do
      let(:greater_than_or_equal_to_validation) { DSLCompose::DSL::DSLMethod::Argument::GreaterThanOrEqualToValidation.new 100 }

      it "returns true if tested with a value larger than the originally provided value" do
        expect(greater_than_or_equal_to_validation.validate(101)).to eq(true)
      end

      it "returns true if tested with a value equal to the originally provided value" do
        expect(greater_than_or_equal_to_validation.validate(100)).to eq(true)
      end

      it "returns false if tested with a value greater than the originally provided value" do
        expect(greater_than_or_equal_to_validation.validate(99)).to eq(false)
      end
    end
  end
end
