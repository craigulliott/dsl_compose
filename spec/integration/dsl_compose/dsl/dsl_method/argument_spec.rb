# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument do
  it "successfully evaluates a DSL with a method which has a required argument" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :integer
        end
      end
    end

    klass.dsl_name do
      method_name 123
    end

    expect(klass.dsls.to_h(:dsl_name)).to eql(
      {
        klass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {
                  required_option_name: 123
                }
              }
            ]
          }
        }
      }
    )
  end

  describe "when evaluating the same DSL in two differrent sub classes" do
    let(:base_class) {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_option_name, :integer
          end
        end
      end
    }

    let(:child_class_1) {
      Class.new(base_class) do
      end
    }

    let(:child_class_2) {
      Class.new(base_class) do
      end
    }

    it "successfully evaluates a DSL within each class and remembers which child class had each execution" do
      child_class_1.dsl_name do
        method_name 123
      end

      child_class_2.dsl_name do
        method_name 4
        method_name 5
        method_name 6
      end

      expect(base_class.dsls.to_h(:dsl_name)).to eql(
        {
          child_class_1 => {
            arguments: {},
            method_calls: {
              method_name: [
                {
                  arguments: {
                    required_option_name: 123
                  }
                }
              ]
            }
          },
          child_class_2 => {
            arguments: {},
            method_calls: {
              method_name: [
                {
                  arguments: {
                    required_option_name: 4
                  }
                },
                {
                  arguments: {
                    required_option_name: 5
                  }
                },
                {
                  arguments: {
                    required_option_name: 6
                  }
                }
              ]
            }
          }
        }
      )
    end
  end

  it "successfully evaluates a DSL with a method which has both a required and an optional argument" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol
          optional :optional_option_name, :integer
        end
      end
    end

    klass.dsl_name do
      method_name :foo, optional_option_name: 456
    end

    expect(klass.dsls.to_h(:dsl_name)).to eql(
      {
        klass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {
                  required_option_name: :foo,
                  optional_option_name: 456
                }
              }
            ]
          }
        }
      }
    )
  end

  it "successfully evaluates a DSL with a method which has both a required array and an optional array argument" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol, array: true
          optional :optional_option_name, :integer, array: true
        end
      end
    end

    klass.dsl_name do
      method_name [:foo], optional_option_name: [456]
    end

    expect(klass.dsls.to_h(:dsl_name)).to eql(
      {
        klass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {
                  required_option_name: [:foo],
                  optional_option_name: [456]
                }
              }
            ]
          }
        }
      }
    )
  end

  it "successfully evaluates a DSL with a method which has both a required array and an optional array argument but where non array values are provided" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol, array: true
          optional :optional_option_name, :integer, array: true
        end
      end
    end

    klass.dsl_name do
      method_name :foo, optional_option_name: 456
    end

    expect(klass.dsls.to_h(:dsl_name)).to eql(
      {
        klass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {
                  required_option_name: [:foo],
                  optional_option_name: [456]
                }
              }
            ]
          }
        }
      }
    )
  end

  it "raises an error if evaluating a DSL with a required method argument, where that argument is not provided" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol
        end
      end
    end

    expect {
      klass.dsl_name do
        method_name
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::MissingRequiredArgumentsError
  end

  it "raises an error if evaluating a DSL and passing more arguments than expected to a method" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol
        end
      end
    end

    expect {
      klass.dsl_name do
        method_name :foo, :bar
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::TooManyArgumentsError
  end

  it "raises an error if evaluating a DSL and passing an arguments of the wrong type" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol
        end
      end
    end

    expect {
      klass.dsl_name do
        method_name 123
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::InvalidArgumentTypeError
  end

  it "raises an error if evaluating a DSL and passing an optional argument where there are no optional arguments defined" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_option_name, :symbol
        end
      end
    end

    expect {
      klass.dsl_name do
        method_name :foo, {hi: :there}
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::TooManyArgumentsError
  end

  it "raises an error if evaluating a DSL and passing an optional argument which was not defined" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_arg_name, :symbol
          optional :optional_arg, :symbol
        end
      end
    end

    expect {
      klass.dsl_name do
        method_name :my_required_arg, {different_optional_arg_name: :val}
      end
    }.to raise_error DSLCompose::DSL::Arguments::ArgumentDoesNotExistError
  end

  it "raises an error if evaluating a DSL and passing an optional argument of an unexpected type" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_arg_name, :symbol
          optional :optional_arg, :symbol
        end
      end
    end

    expect {
      klass.dsl_name do
        method_name :my_required_arg, {optional_arg: 123}
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::InvalidArgumentTypeError
  end
end
