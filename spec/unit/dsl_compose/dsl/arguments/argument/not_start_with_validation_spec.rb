# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::NotStartWithValidation do
  describe :initialize do
    it "initializes a new NotStartWithValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::NotStartWithValidation.new :foo_
      }.to_not raise_error
    end

    describe :validate do
      let(:not_start_with_validation) { DSLCompose::DSL::Arguments::Argument::NotStartWithValidation.new :foo_ }

      it "does not raise an error if tested with a value which does not start with the provided value" do
        expect {
          not_start_with_validation.validate!("something_else")
        }.to_not raise_error
      end

      it "does not raise an error if tested with a Symbol value which does not start with the provided value" do
        expect {
          not_start_with_validation.validate!(:something_else)
        }.to_not raise_error
      end

      it "raises an error if tested with a string value which does start with the provided value" do
        expect {
          not_start_with_validation.validate!("foo_bar_baz")
        }.to raise_error DSLCompose::DSL::Arguments::Argument::NotStartWithValidation::ValidationFailedError
      end

      it "raises an error if tested with a symbol value which does start with the provided value" do
        expect {
          not_start_with_validation.validate!(:foo_bar_baz)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::NotStartWithValidation::ValidationFailedError
      end

      describe "when initialized with an array of values" do
        let(:not_start_with_validation) { DSLCompose::DSL::Arguments::Argument::NotStartWithValidation.new [:foo_, :bar_] }

        it "does not raise an error if tested with a value which does not start with the provided value" do
          expect {
            not_start_with_validation.validate!("something_else")
          }.to_not raise_error
        end

        it "does not raise an error if tested with a Symbol value which does not start with the provided value" do
          expect {
            not_start_with_validation.validate!(:something_else)
          }.to_not raise_error
        end

        it "raises an error if tested with a string value which does start with the provided value" do
          expect {
            not_start_with_validation.validate!("foo_bar_baz")
          }.to raise_error DSLCompose::DSL::Arguments::Argument::NotStartWithValidation::ValidationFailedError
        end

        it "raises an error if tested with a symbol value which does start with the provided value" do
          expect {
            not_start_with_validation.validate!(:foo_bar_baz)
          }.to raise_error DSLCompose::DSL::Arguments::Argument::NotStartWithValidation::ValidationFailedError
        end
      end
    end
  end
end
