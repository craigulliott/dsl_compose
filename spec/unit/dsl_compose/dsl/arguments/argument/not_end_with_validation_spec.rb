# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::NotEndWithValidation do
  describe :initialize do
    it "initializes a new NotEndWithValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::NotEndWithValidation.new :_foo
      }.to_not raise_error
    end

    describe :validate do
      let(:not_end_with_validation) { DSLCompose::DSL::Arguments::Argument::NotEndWithValidation.new :_foo }

      it "does not raise an error if tested with a value which does not end with the provided value" do
        expect {
          not_end_with_validation.validate!("something_else")
        }.to_not raise_error
      end

      it "does not raise an error if tested with a Symbol value which does not end with the provided value" do
        expect {
          not_end_with_validation.validate!(:something_else)
        }.to_not raise_error
      end

      it "raises an error if tested with a string value which does end with the provided value" do
        expect {
          not_end_with_validation.validate!("bar_baz_foo")
        }.to raise_error DSLCompose::DSL::Arguments::Argument::NotEndWithValidation::ValidationFailedError
      end

      it "raises an error if tested with a symbol value which does end with the provided value" do
        expect {
          not_end_with_validation.validate!(:bar_baz_foo)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::NotEndWithValidation::ValidationFailedError
      end

      describe "when initialized with an array of values" do
        let(:not_end_with_validation) { DSLCompose::DSL::Arguments::Argument::NotEndWithValidation.new [:_foo, :_bar] }

        it "does not raise an error if tested with a value which does not end with the provided value" do
          expect {
            not_end_with_validation.validate!("something_else")
          }.to_not raise_error
        end

        it "does not raise an error if tested with a Symbol value which does not end with the provided value" do
          expect {
            not_end_with_validation.validate!(:something_else)
          }.to_not raise_error
        end

        it "raises an error if tested with a string value which does end with the provided value" do
          expect {
            not_end_with_validation.validate!("bar_baz_foo")
          }.to raise_error DSLCompose::DSL::Arguments::Argument::NotEndWithValidation::ValidationFailedError
        end

        it "raises an error if tested with a symbol value which does end with the provided value" do
          expect {
            not_end_with_validation.validate!(:bar_baz_foo)
          }.to raise_error DSLCompose::DSL::Arguments::Argument::NotEndWithValidation::ValidationFailedError
        end
      end
    end
  end
end
