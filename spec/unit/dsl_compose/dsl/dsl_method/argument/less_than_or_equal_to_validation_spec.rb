# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::LessThanOrEqualToValidation do
  describe :initialize do
    it "initializes a new LessThanOrEqualToValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::LessThanOrEqualToValidation.new 100
    end

    it "raises an error if initializing the LessThanOrEqualToValidation with a string instead of a number" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::LessThanOrEqualToValidation.new "100"
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::LessThanOrEqualToValidation::InvalidValueError)
    end

    describe :validate do
      let(:less_than_or_equal_to_validation) { DSLCompose::DSL::DSLMethod::Argument::LessThanOrEqualToValidation.new 100 }

      it "returns false if tested with a value larger than the originally provided value" do
        expect(less_than_or_equal_to_validation.validate(101)).to eq(false)
      end

      it "returns true if tested with a value equal to the originally provided value" do
        expect(less_than_or_equal_to_validation.validate(100)).to eq(true)
      end

      it "returns true if tested with a value less than the originally provided value" do
        expect(less_than_or_equal_to_validation.validate(99)).to eq(true)
      end
    end
  end
end
