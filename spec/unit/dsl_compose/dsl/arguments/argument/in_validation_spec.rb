# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::InValidation do
  describe :initialize do
    it "initializes a new InValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::InValidation.new [100]
      }.to_not raise_error
    end

    it "raises an error if initializing the InValidation with a number instead of an Array" do
      expect {
        DSLCompose::DSL::Arguments::Argument::InValidation.new 100
      }.to raise_error(DSLCompose::DSL::Arguments::Argument::InValidation::InvalidValueError)
    end

    describe :validate do
      let(:in_validation) { DSLCompose::DSL::Arguments::Argument::InValidation.new [100] }

      it "does not raise an error if tested with a value not in the originally provided array" do
        expect {
          in_validation.validate!(100)
        }.to_not raise_error
      end

      it "raises an error if tested with a value in the originally provided array" do
        expect {
          in_validation.validate!(50)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::InValidation::ValidationFailedError
      end
    end
  end
end
