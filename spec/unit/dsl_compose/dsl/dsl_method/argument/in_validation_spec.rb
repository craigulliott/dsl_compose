# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::InValidation do
  describe :initialize do
    it "initializes a new InValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::InValidation.new [100]
    end

    it "raises an error if initializing the InValidation with a number instead of an Array" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::InValidation.new 100
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InValidation::InvalidValueError)
    end

    describe :validate do
      let(:in_validation) { DSLCompose::DSL::DSLMethod::Argument::InValidation.new [100] }

      it "returns false if tested with a value not in the originally provided array" do
        expect(in_validation.validate(50)).to eq(false)
      end

      it "returns true if tested with a value in the originally provided array" do
        expect(in_validation.validate(100)).to eq(true)
      end
    end
  end
end
