# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::NotInValidation do
  describe :initialize do
    it "initializes a new NotInValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::NotInValidation.new [100]
      }.to_not raise_error
    end

    it "raises an error if initializing the NotInValidation with a number instead of an Array" do
      expect {
        DSLCompose::DSL::Arguments::Argument::NotInValidation.new 100
      }.to raise_error(DSLCompose::DSL::Arguments::Argument::NotInValidation::InvalidValueError)
    end

    describe :validate do
      let(:not_in_validation) { DSLCompose::DSL::Arguments::Argument::NotInValidation.new [100] }

      it "does not raise an error if tested with a value not in the originally provided array" do
        expect {
          not_in_validation.validate!(50)
        }.to_not raise_error
      end

      it "raises an error if tested with a value in the originally provided array" do
        expect {
          not_in_validation.validate!(100)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::NotInValidation::ValidationFailedError
      end
    end
  end
end
