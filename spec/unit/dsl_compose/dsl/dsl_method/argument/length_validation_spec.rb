# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::LengthValidation do
  describe :initialize do
    it "initializes a new LengthValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::LengthValidation.new is: 10
    end

    describe :validate do
      let(:length_validation) { DSLCompose::DSL::DSLMethod::Argument::LengthValidation.new is: 10 }

      describe "when the :is option is provided" do
        it "returns false if tested with a string with length not equal to the provided value" do
          expect(length_validation.validate("abcd")).to eq(false)
        end

        it "returns true if tested with a string with length not equal to the provided value" do
          expect(length_validation.validate("abcdefghij")).to eq(true)
        end
      end
    end
  end
end
