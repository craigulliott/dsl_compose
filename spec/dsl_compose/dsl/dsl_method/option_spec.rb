# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Option do
  it "creates a new DSL with methods and a required option within the class" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :string
        end
      end
    end
    expect(klass.get_dsl(:dsl_name).get_dsl_methods.count).to eq(1)
  end

  it "raises an error if using a string instead of a symbol for the option name" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires "required_option_name", :string
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::Option::Errors::InvalidName)
  end

  it "creates a new DSL with methods and options within the class" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :string
          optional :optional_option_name, :string
        end
      end
    end
    expect(klass.get_dsl(:dsl_name).get_dsl_methods.count).to eq(1)
  end

  it "raises an error if adding a method option with an invalid type" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :not_a_real_type
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::Option::Errors::InvalidType)
  end

  it "raises an error if adding multiple method options with the same name" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :string
            requires :required_option_name, :string
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::Errors::OptionAlreadyExists)
  end

  it "raises an error if adding required method options after optional ones" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            optional :optional_option_name, :string
            requires :required_option_name, :string
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::Errors::OptionOrdering)
  end

  it "raises an error if adding multiple method option validations of the same type" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :integer do
              validate_greater_than 0
              validate_greater_than 0
            end
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::Option::Errors::ValidationAlreadyExists)
  end

  it "raises an error if adding number validations on string types" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :string do
              validate_greater_than 0
            end
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::Option::Errors::ValidationIncompatible)
  end
end
