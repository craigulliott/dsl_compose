# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod do
  it "successfully evaluates a DSL with a method, where the method has no configuration block" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    TestClass.dsl_name do
      method_name
    end

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {}
              }
            ]
          }
        }
      }
    )
  end

  it "successfully evaluates a DSL with a method, where the method is called twice" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    TestClass.dsl_name do
      method_name
      method_name
    end

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {}
              },
              {
                arguments: {}
              }
            ]
          }
        }
      }
    )
  end

  it "successfully evaluates a DSL with a unique method" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_unique_method :method_name
      end
    end

    TestClass.dsl_name do
      method_name
    end

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {}
              }
            ]
          }
        }
      }
    )
  end

  it "raises an error if evaluating a DSL where a unique method is called twice" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_unique_method :method_name
      end
    end

    expect {
      TestClass.dsl_name do
        method_name
        method_name
      end
    }.to raise_error DSLCompose::Interpreter::Execution::MethodIsUniqueError
  end

  it "successfully evaluates a DSL with a required method" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name, required: true
      end
    end

    TestClass.dsl_name do
      method_name
    end

    expect(TestClass.dsls.to_h(:dsl_name)).to eql(
      {
        TestClass => {
          arguments: {},
          method_calls: {
            method_name: [
              {
                arguments: {}
              }
            ]
          }
        }
      }
    )

    expect(DSLCompose::DSLs.class_dsl(TestClass, :dsl_name).dsl_methods.count).to eq(1)
  end

  it "raises an error if evaluating a DSL where a required method is not called" do
    create_class :TestClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name, required: true
      end
    end

    expect {
      TestClass.dsl_name do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::RequiredMethodNotCalledError
  end

  describe "extending an empty DSL" do
    before(:each) do
      create_class :TestClassWithEmptyDSL do
        include DSLCompose::Composer
        define_dsl :dsl_name do
        end
      end
    end

    it "allows adding a new method and evaluating the DSL" do
      TestClassWithEmptyDSL.define_dsl :dsl_name do
        add_method :method_name
      end

      TestClassWithEmptyDSL.dsl_name do
        method_name
      end

      expect(TestClassWithEmptyDSL.dsls.to_h(:dsl_name)).to eql(
        {
          TestClassWithEmptyDSL => {
            arguments: {},
            method_calls: {
              method_name: [
                {
                  arguments: {}
                }
              ]
            }
          }
        }
      )
    end
  end

  describe "extending a DSL which already has a method" do
    before(:each) do
      create_class :TestClassWhichAlreadyHasAMethod do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name
        end
      end
    end

    it "allows adding a method with a different name and evaluating the DSL with both methods" do
      TestClassWhichAlreadyHasAMethod.define_dsl :dsl_name do
        add_method :another_method_name
      end

      TestClassWhichAlreadyHasAMethod.dsl_name do
        method_name
        another_method_name
      end

      expect(TestClassWhichAlreadyHasAMethod.dsls.to_h(:dsl_name)).to eql(
        {
          TestClassWhichAlreadyHasAMethod => {
            arguments: {},
            method_calls: {
              method_name: [
                {
                  arguments: {}
                }
              ],
              another_method_name: [
                {
                  arguments: {}
                }
              ]
            }
          }
        }
      )
    end

    it "raises an error if adding a method with the same name" do
      expect {
        TestClassWhichAlreadyHasAMethod.define_dsl :dsl_name do
          add_method :method_name
        end
      }.to raise_error(DSLCompose::DSL::MethodAlreadyExistsError)
    end
  end
end
