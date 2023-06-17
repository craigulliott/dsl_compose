# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::NotInValidation do
  describe :initialize do
    it "initializes a new NotInValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::NotInValidation.new [100]
    end

    it "raises an error if initializing the NotInValidation with a number instead of an Array" do
      expect {
        DSLCompose::DSL::DSLMethod::Argument::NotInValidation.new 100
      }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::NotInValidation::InvalidValueError)
    end

    describe :validate do
      let(:not_in_validation) { DSLCompose::DSL::DSLMethod::Argument::NotInValidation.new [100] }

      it "returns true if tested with a value not in the originally provided array" do
        expect(not_in_validation.validate(50)).to eq(true)
      end

      it "returns false if tested with a value in the originally provided array" do
        expect(not_in_validation.validate(100)).to eq(false)
      end
    end
  end
end
