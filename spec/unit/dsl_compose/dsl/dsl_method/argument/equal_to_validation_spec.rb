# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::EqualToValidation do
  describe :initialize do
    it "initializes a new EqualToValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::EqualToValidation.new 100
    end

    describe :validate do
      let(:equal_to_validation) { DSLCompose::DSL::DSLMethod::Argument::EqualToValidation.new 100 }

      it "returns false if tested with a value different to the originally provided value" do
        expect(equal_to_validation.validate(50)).to eq(false)
      end

      it "returns true if tested with the same value to the originally provided value" do
        expect(equal_to_validation.validate(100)).to eq(true)
      end
    end
  end
end
