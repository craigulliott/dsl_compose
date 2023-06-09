# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::EndWithValidation do
  describe :initialize do
    it "initializes a new EndWithValidation without raising any errors" do
      expect {
        DSLCompose::DSL::Arguments::Argument::EndWithValidation.new :_foo
      }.to_not raise_error
    end

    describe :validate do
      let(:end_with_validation) { DSLCompose::DSL::Arguments::Argument::EndWithValidation.new :_foo }

      it "raises an error if tested with a value which does not end with the provided value" do
        expect {
          end_with_validation.validate!("something_else")
        }.to raise_error DSLCompose::DSL::Arguments::Argument::EndWithValidation::ValidationFailedError
      end

      it "raises an error if tested with a Symbol value which does not end with the provided value" do
        expect {
          end_with_validation.validate!(:something_else)
        }.to raise_error DSLCompose::DSL::Arguments::Argument::EndWithValidation::ValidationFailedError
      end

      it "does not raise an error if tested with a string value which does end with the provided value" do
        expect {
          end_with_validation.validate!("bar_baz_foo")
        }.to_not raise_error
      end

      it "does not raise an error if tested with a symbol value which does end with the provided value" do
        expect {
          end_with_validation.validate!(:bar_baz_foo)
        }.to_not raise_error
      end

      describe "when initialized with an array of values" do
        let(:end_with_validation) { DSLCompose::DSL::Arguments::Argument::EndWithValidation.new [:_foo, :_bar] }

        it "raises an error if tested with a value which does not end with the provided value" do
          expect {
            end_with_validation.validate!("something_else")
          }.to raise_error DSLCompose::DSL::Arguments::Argument::EndWithValidation::ValidationFailedError
        end

        it "raises an error if tested with a Symbol value which does not end with the provided value" do
          expect {
            end_with_validation.validate!(:something_else)
          }.to raise_error DSLCompose::DSL::Arguments::Argument::EndWithValidation::ValidationFailedError
        end

        it "does not raise an error if tested with a string value which does end with the provided value" do
          expect {
            end_with_validation.validate!("bar_baz_foo")
          }.to_not raise_error
        end

        it "does not raise an error if tested with a symbol value which does end with the provided value" do
          expect {
            end_with_validation.validate!(:bar_baz_foo)
          }.to_not raise_error
        end
      end
    end
  end
end
