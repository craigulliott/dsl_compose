# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument do
  it "successfully evaluates a DSL with a method which has a required argument and no block provided" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :integer
      end
    end

    TestClass.dsl_name 123

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {
            required_option_name: 123
          },
          method_calls: {}
        }
      }
    )
  end

  it "successfully evaluates a DSL with a method which has a required argument and a block provided" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :integer
      end
    end

    TestClass.dsl_name 123 do
    end

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {
            required_option_name: 123
          },
          method_calls: {}
        }
      }
    )
  end

  describe "when evaluating the same DSL in two differrent sub classes" do
    before(:each) do
      create_class :BaseClass do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          requires :required_option_name, :integer
        end
      end

      create_class :ChildClass1, BaseClass do
      end

      create_class :ChildClass2, BaseClass do
      end
    end

    it "successfully evaluates a DSL within each class and remembers which child class had each execution" do
      ChildClass1.dsl_name 123

      ChildClass2.dsl_name 456

      expect(BaseClass.dsls.to_h(:dsl_name)).to eql(
        {
          ChildClass1 => {
            arguments: {
              required_option_name: 123
            },
            method_calls: {}
          },
          ChildClass2 => {
            arguments: {
              required_option_name: 456
            },
            method_calls: {}
          }
        }
      )
    end
  end

  it "successfully evaluates a DSL with a method which has both a required and an optional argument" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol
        optional :optional_option_name, :integer
      end
    end

    TestClass.dsl_name :foo, optional_option_name: 456

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {
            required_option_name: :foo,
            optional_option_name: 456
          },
          method_calls: {}
        }
      }
    )
  end

  it "successfully evaluates a DSL with a method which has both a required array and an optional array argument" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol, array: true
        optional :optional_option_name, :integer, array: true
      end
    end

    TestClass.dsl_name [:foo], optional_option_name: [456]

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {
            required_option_name: [:foo],
            optional_option_name: [456]
          },
          method_calls: {}
        }
      }
    )
  end

  it "successfully evaluates a DSL with a method which has both a required array and an optional array argument but where non array values are provided" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol, array: true
        optional :optional_option_name, :integer, array: true
      end
    end

    TestClass.dsl_name :foo, optional_option_name: 456

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {
            required_option_name: [:foo],
            optional_option_name: [456]
          },
          method_calls: {}
        }
      }
    )
  end

  it "raises an error if evaluating a DSL with a required argument argument, where that argument is not provided" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol
      end
    end

    expect {
      TestClass.dsl_name do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::MissingRequiredArgumentsError
  end

  it "raises an error if evaluating a DSL and passing more arguments than expected to a method" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol
      end
    end

    expect {
      TestClass.dsl_name :foo, :bar do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::TooManyArgumentsError
  end

  it "raises an error if evaluating a DSL and passing an arguments of the wrong type" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol
      end
    end

    expect {
      TestClass.dsl_name 123 do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::InvalidArgumentTypeError
  end

  it "raises an error if evaluating a DSL and passing an optional argument where there are no optional arguments defined" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_option_name, :symbol
      end
    end

    expect {
      TestClass.dsl_name :foo, {hi: :there} do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::TooManyArgumentsError
  end

  it "raises an error if evaluating a DSL and passing an optional argument which was not defined" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_arg_name, :symbol
        optional :optional_arg, :symbol
      end
    end

    expect {
      TestClass.dsl_name :my_required_arg, {different_optional_arg_name: :val} do
      end
    }.to raise_error DSLCompose::DSL::Arguments::ArgumentDoesNotExistError
  end

  it "raises an error if evaluating a DSL and passing an optional argument of an unexpected type" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_arg_name, :symbol
        optional :optional_arg, :symbol
      end
    end

    expect {
      TestClass.dsl_name :my_required_arg, {optional_arg: 123} do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::InvalidArgumentTypeError
  end

  it "raises an error if evaluating a DSL and passing an optional argument of an unexpected type to an argument which accepts an array" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_arg_name, :symbol
        optional :optional_arg, :symbol, array: true
      end
    end

    expect {
      TestClass.dsl_name :my_required_arg, {optional_arg: [123]} do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::InvalidArgumentTypeError
  end

  it "raises an error if evaluating a DSL and passing an array of values to an optional argument which does not accept arrays" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :required_arg_name, :symbol
        optional :optional_arg, :symbol
      end
    end

    expect {
      TestClass.dsl_name :my_required_arg, {optional_arg: [123]} do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::Arguments::ArrayNotValidError
  end
end
