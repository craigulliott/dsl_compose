# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::EndWithValidation do
  describe "for a DSL that has a a method which includes a validated argument" do
    before(:each) do
      create_class :FooModel do
      end

      create_class :TestClass do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :class do
              validate_end_with :Model
            end
          end
        end
      end
    end

    it "does not raise an error evaluating the DSL when a valid argument is provided to the method" do
      expect {
        TestClass.dsl_name do
          method_name "FooModel"
        end
      }.to_not raise_error
    end

    it "raises an error when evaluating a DSL with an invalid argument provided to the method" do
      expect {
        TestClass.dsl_name do
          method_name "UnexpectedClassName"
        end
      }.to raise_error DSLCompose::DSL::Arguments::Argument::EndWithValidation::ValidationFailedError
    end
  end
end
