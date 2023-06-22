# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::FormatValidation do
  describe :initialize do
    it "initializes a new FormatValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::FormatValidation.new(/\A[A-Z][a-z]+\Z/)
      }.to_not raise_error
    end

    describe :validate do
      let(:format_validation) { DSLCompose::DSL::Arguments::Argument::FormatValidation.new(/\A[A-Z][a-z]+\Z/) }

      it "does not raise an error if tested with a value that matches the provided regex" do
        expect {
          format_validation.validate!("Aaa")
        }.to_not raise_error
      end

      it "returns false if tested with a value that does not matche the provided regex" do
        expect {
          format_validation.validate!("100")
        }.to raise_error DSLCompose::DSL::Arguments::Argument::FormatValidation::ValidationFailedError
      end
    end
  end
end
