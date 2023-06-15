# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DSLCompose::DSL::Interpreter do

  it "allows use of the DSL within the same class without raising any errors" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end

      dsl_name do
        method_name
      end
    end

    expect(klass.get_dsl(:dsl_name).get_dsl_methods.count).to eq(1)
  end

  it "allows use of the DSL within a child class without raising any errors" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    child_klass = Class.new(klass) do
      dsl_name do
        method_name
      end
    end
  end

  it "raises an error if calling a method within the DSL which does not exist" do
    expect {
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name
        end
      end

      child_klass = Class.new(klass) do
        dsl_name do
          unexpected_method_name
        end
      end
    }.to raise_error(DSLCompose::DSL::Interpreter::Errors::MethodDoesNotExist)
  end

  it "allows calling a method within a DSL twice" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name
      end
    end

    child_klass = Class.new(klass) do
      dsl_name do
        method_name
        method_name
      end
    end
  end

  it "raises an error if calling a unique method within a DSL twice" do
    expect {
      klass = Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_unique_method :unique_method
        end
      end

      child_klass = Class.new(klass) do
        dsl_name do
          unique_method
          unique_method
        end
      end
    }.to raise_error(DSLCompose::DSL::Interpreter::Errors::MethodIsUnique)
  end


end