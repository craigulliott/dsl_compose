# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Interpreter::Execution::MethodCalls::MethodCall do
  it "allows use of the DSL within the same class without raising any errors" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
        end
      end

      dsl_name do
        method_name
      end
    end

    expect(klass.get_dsl(:dsl_name).dsl_methods.count).to eq(1)
  end
end
