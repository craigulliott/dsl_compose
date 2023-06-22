# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod do
  let(:dummy_class) { Class.new { include DSLCompose::Composer } }

  it "successfully evaluates a DSL with a method, where the method has no configuration block" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    klass.dsl_name do
      method_name
    end

    expect(klass.dsl_interpreter.to_h(:dsl_name)).to eql(
      {
        klass => {
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
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    klass.dsl_name do
      method_name
      method_name
    end

    expect(klass.dsl_interpreter.to_h(:dsl_name)).to eql(
      {
        klass => {
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
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_unique_method :method_name
      end
    end

    klass.dsl_name do
      method_name
    end

    expect(klass.dsl_interpreter.to_h(:dsl_name)).to eql(
      {
        klass => {
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
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_unique_method :method_name
      end
    end

    expect {
      klass.dsl_name do
        method_name
        method_name
      end
    }.to raise_error DSLCompose::Interpreter::Execution::MethodIsUniqueError
  end

  it "successfully evaluates a DSL with a required method" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name, required: true
      end
    end

    klass.dsl_name do
      method_name
    end

    expect(klass.dsl_interpreter.to_h(:dsl_name)).to eql(
      {
        klass => {
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

    expect(DSLCompose::DSLs.class_dsl(klass, :dsl_name).dsl_methods.count).to eq(1)
  end

  it "raises an error if evaluating a DSL where a required method is not called" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name, required: true
      end
    end

    expect {
      klass.dsl_name do
      end
    }.to raise_error DSLCompose::Interpreter::Execution::RequiredMethodNotCalledError
  end

  describe "extending an empty DSL" do
    let(:dummy_class) { Class.new { include DSLCompose::Composer } }

    before(:each) do
      dummy_class.define_dsl :dsl_name do
      end
    end

    it "allows adding a new method and evaluating the DSL" do
      dummy_class.define_dsl :dsl_name do
        add_method :method_name
      end

      dummy_class.dsl_name do
        method_name
      end

      expect(dummy_class.dsl_interpreter.to_h(:dsl_name)).to eql(
        {
          dummy_class => {
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
    let(:dummy_class) { Class.new { include DSLCompose::Composer } }

    before(:each) do
      dummy_class.define_dsl :dsl_name do
        add_method :method_name
      end
    end

    it "allows adding a method with a different name and evaluating the DSL with both methods" do
      dummy_class.define_dsl :dsl_name do
        add_method :another_method_name
      end

      dummy_class.dsl_name do
        method_name
        another_method_name
      end

      expect(dummy_class.dsl_interpreter.to_h(:dsl_name)).to eql(
        {
          dummy_class => {
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
        dummy_class.define_dsl :dsl_name do
          add_method :method_name
        end
      }.to raise_error(DSLCompose::DSL::MethodAlreadyExistsError)
    end
  end
end
