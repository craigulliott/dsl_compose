# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::LengthValidation do
  describe :initialize do
    it "initializes a new LengthValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::LengthValidation.new is: 10
      }.to_not raise_error
    end

    describe :validate do
      let(:length_validation) { DSLCompose::DSL::Arguments::Argument::LengthValidation.new is: 10 }

      describe "when the :is option is provided" do
        it "raises an error if tested with a string with length not equal to the provided value" do
          expect {
            length_validation.validate!("abcd")
          }.to raise_error DSLCompose::DSL::Arguments::Argument::LengthValidation::ValidationFailedError
        end

        it "does not raise an error if tested with a string with length not equal to the provided value" do
          expect {
            length_validation.validate!("abcdefghij")
          }.to_not raise_error
        end
      end
    end
  end
end
