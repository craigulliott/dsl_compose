# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::FormatValidation do
  describe :initialize do
    it "initializes a new FormatValidation without raising any errors" do
      DSLCompose::DSL::DSLMethod::Argument::FormatValidation.new(/\A[A-Z][a-z]+\Z/)
    end

    describe :validate do
      let(:format_validation) { DSLCompose::DSL::DSLMethod::Argument::FormatValidation.new(/\A[A-Z][a-z]+\Z/) }

      it "returns true if tested with a value that matches the provided regex" do
        expect(format_validation.validate("Aaa")).to eq(true)
      end

      it "returns false if tested with a value that does not matche the provided regex" do
        expect(format_validation.validate("100")).to eq(false)
      end
    end
  end
end
