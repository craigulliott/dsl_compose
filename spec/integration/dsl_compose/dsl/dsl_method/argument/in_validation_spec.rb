# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument::InValidation do
  describe "for a DSL that has a a method which includes a validated argument" do
    let(:dummy_class) {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :symbol do
              validate_in([:foo, :bar])
            end
          end
        end
      end
    }

    it "successfully evaluates the DSL when a valid argument is provided to the method" do
      dummy_class.dsl_name do
        method_name :foo
      end

      expect(dummy_class.dsl_interpreter.to_h(dummy_class)).to eql(
        {
          dsl_name: {
            method_name: [
              {
                arguments: {
                  required_option_name: :foo
                }
              }
            ]
          }
        }
      )
    end

    it "raises an error when evaluating a DSL with an invalid argument provided to the method" do
      expect {
        dummy_class.dsl_name do
          method_name :unexpected
        end
      }.to raise_error DSLCompose::DSL::DSLMethod::Argument::InValidation::ValidationFailedError
    end
  end
end
