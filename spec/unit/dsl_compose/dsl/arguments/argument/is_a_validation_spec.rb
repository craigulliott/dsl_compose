# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::IsAValidation do
  describe :initialize do
    it "initializes a new IsAValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::IsAValidation.new Regexp
      }.to_not raise_error
    end

    describe :validate do
      let(:is_a_validation) { DSLCompose::DSL::Arguments::Argument::IsAValidation.new Regexp }

      it "raises an error if tested with a value type different to the class with the originally provided class name" do
        expect {
          is_a_validation.validate!(50)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::IsAValidation::ValidationFailedError
      end

      it "does not raise an error if tested with the same value type as the class with the originally provided class name" do
        expect {
          is_a_validation.validate!(/[a-z]/)
        }.to_not raise_error
      end
    end
  end
end
