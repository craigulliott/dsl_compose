# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::EqualToValidation do
  describe :initialize do
    it "initializes a new EqualToValidation without raising any errors" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::EqualToValidation.new 100
      }.to_not raise_error
    end

    describe :validate do
      let(:equal_to_validation) { DSLCompose::DSL::DSLMethod::Argument::EqualToValidation.new 100 }

      it "raises an error if tested with a value different to the originally provided value" do
        expect {
          equal_to_validation.validate!(50)
        }.to raise_error DSLCompose::DSL::DSLMethod::Argument::EqualToValidation::ValidationFailedError
      end

      it "does not raise an error if tested with the same value to the originally provided value" do
        expect {
          equal_to_validation.validate!(100)
        }.to_not raise_error
      end
    end
  end
end
