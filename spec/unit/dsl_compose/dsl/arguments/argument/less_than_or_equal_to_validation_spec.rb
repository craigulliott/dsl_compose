# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation do
  describe :initialize do
    it "initializes a new LessThanOrEqualToValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation.new 100
      }.to_not raise_error
    end

    it "raises an error if initializing the LessThanOrEqualToValidation with a string instead of a number" do
      expect {
        DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation.new "100"
      }.to raise_error(DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation::InvalidValueError)
    end

    describe :validate do
      let(:less_than_or_equal_to_validation) { DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation.new 100 }

      it "raises an error if tested with a value larger than the originally provided value" do
        expect {
          less_than_or_equal_to_validation.validate!(101)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::LessThanOrEqualToValidation::ValidationFailedError
      end

      it "does not raise an error if tested with a value equal to the originally provided value" do
        expect {
          less_than_or_equal_to_validation.validate!(100)
        }.to_not raise_error
      end

      it "does not raise an error if tested with a value less than the originally provided value" do
        expect {
          less_than_or_equal_to_validation.validate!(99)
        }.to_not raise_error
      end
    end
  end
end
