# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument::InValidation do
  describe "for a DSL that has a a method which includes a validated argument" do
    before(:each) do
      create_class :TestClass do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :symbol do
              validate_in([:foo, :bar])
            end
          end
        end
      end
    end

    it "successfully evaluates the DSL when a valid argument is provided to the method" do
      TestClass.dsl_name do
        method_name :foo
      end

      expect(TestClass.dsls.to_h(:dsl_name)).to eql(
        {
          TestClass => {
            arguments: {},
            method_calls: {
              method_name: [
                {
                  arguments: {
                    required_option_name: :foo
                  }
                }
              ]
            }
          }
        }
      )
    end

    it "raises an error when evaluating a DSL with an invalid argument provided to the method" do
      expect {
        TestClass.dsl_name do
          method_name :unexpected
        end
      }.to raise_error DSLCompose::DSL::Arguments::Argument::InValidation::ValidationFailedError
    end
  end
end
