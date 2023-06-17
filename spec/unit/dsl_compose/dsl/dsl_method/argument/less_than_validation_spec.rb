# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::LessThanValidation do
  describe :initialize do
    it "initializes a new LessThanValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::LessThanValidation.new 100
    end

    it "raises an error if initializing the LessThanValidation with a string instead of a number" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::LessThanValidation.new "100"
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::LessThanValidation::InvalidValueError)
    end

    describe :validate do
      let(:less_than_validation) { DSLCompose::DSL::DSLMethod::Argument::LessThanValidation.new 100 }

      it "returns false if tested with a value larger than the originally provided value" do
        expect(less_than_validation.validate(101)).to eq(false)
      end

      it "returns false if tested with a value equal to the originally provided value" do
        expect(less_than_validation.validate(100)).to eq(false)
      end

      it "returns true if tested with a value less than the originally provided value" do
        expect(less_than_validation.validate(99)).to eq(true)
      end
    end
  end
end
