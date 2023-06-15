# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod::Argument do
  it "creates a new DSL with methods and a required option within the class" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :string
        end
      end
    end
    expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
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
    }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InvalidNameError)
  end

  it "creates a new DSL with methods and arguments within the class" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :string
          optional :optional_option_name, :string
        end
      end
    end
    expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
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
    }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::InvalidTypeError)
  end

  it "raises an error if adding multiple method arguments with the same name" do
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
    }.to raise_error(DSLCompose::DSL::DSLMethod::ArgumentAlreadyExistsError)
  end

  it "raises an error if adding required method arguments after optional ones" do
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
    }.to raise_error(DSLCompose::DSL::DSLMethod::ArgumentOrderingError)
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
    }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationAlreadyExistsError)
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
    }.to raise_error(DSLCompose::DSL::DSLMethod::Argument::ValidationIncompatibleError)
  end
end
