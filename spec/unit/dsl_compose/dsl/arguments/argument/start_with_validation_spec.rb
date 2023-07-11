# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::StartWithValidation do
  describe :initialize do
    it "initializes a new StartWithValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::StartWithValidation.new :foo_
      }.to_not raise_error
    end

    describe :validate do
      let(:start_with_validation) { DSLCompose::DSL::Arguments::Argument::StartWithValidation.new :foo_ }

      it "raises an error if tested with a value which does not start with the provided value" do
        expect {
          start_with_validation.validate!("something_else")
        }.to raise_error DSLCompose::DSL::Arguments::Argument::StartWithValidation::ValidationFailedError
      end

      it "raises an error if tested with a Symbol value which does not start with the provided value" do
        expect {
          start_with_validation.validate!(:something_else)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::StartWithValidation::ValidationFailedError
      end

      it "does not raise an error if tested with a string value which does start with the provided value" do
        expect {
          start_with_validation.validate!("foo_bar_baz")
        }.to_not raise_error
      end

      it "does not raise an error if tested with a symbol value which does start with the provided value" do
        expect {
          start_with_validation.validate!(:foo_bar_baz)
        }.to_not raise_error
      end

      describe "when initialized with an array of values" do
        let(:start_with_validation) { DSLCompose::DSL::Arguments::Argument::StartWithValidation.new [:foo_, :bar_] }

        it "raises an error if tested with a value which does not start with the provided value" do
          expect {
            start_with_validation.validate!("something_else")
          }.to raise_error DSLCompose::DSL::Arguments::Argument::StartWithValidation::ValidationFailedError
        end

        it "raises an error if tested with a Symbol value which does not start with the provided value" do
          expect {
            start_with_validation.validate!(:something_else)
          }.to raise_error DSLCompose::DSL::Arguments::Argument::StartWithValidation::ValidationFailedError
        end

        it "does not raise an error if tested with a string value which does start with the provided value" do
          expect {
            start_with_validation.validate!("foo_bar_baz")
          }.to_not raise_error
        end

        it "does not raise an error if tested with a symbol value which does start with the provided value" do
          expect {
            start_with_validation.validate!(:foo_bar_baz)
          }.to_not raise_error
        end
      end
    end
  end
end
