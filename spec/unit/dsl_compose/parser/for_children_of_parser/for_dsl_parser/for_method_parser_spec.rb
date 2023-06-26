# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser do
  let(:base_class) do
    Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :arg_name, :symbol
        add_method :method_name do
          requires :method_arg_name, :symbol
        end
      end
    end
  end
  let(:child_class) {
    Class.new(base_class) do
      dsl_name :foo do
        method_name :bar
      end
    end
  }
  let(:dsl_execution) { base_class.dsls.class_dsl_executions(child_class, :dsl_name).first }

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name do
        end
      }.to_not raise_error
    end

    it "raises an error if the provided method name does exist within the scoped DSLs" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :unexpected_method_name do
        end
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser::MethodDoesNotExistError
    end

    it "accepts an array of method names and initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, [:method_name] do
        end
      }.to_not raise_error
    end

    it "raises an error if a block is not provided to the initializer" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser::NoBlockProvided
    end

    it "raises an error if the provided block has unexpected argument types" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name do |unexpected_argument|
        end
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser::AllBlockParametersMustBeKeywordParametersError
    end

    it "raises an error if the provided block has unexpected keyword arguments" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name do |unexpected_keyword_argument:|
        end
      }.to raise_error ArgumentError
    end

    it "optionally passes the method_name to the provided block" do
      mn = nil
      DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name do |method_name:|
        mn = method_name
      end
      expect(mn).to eq(:method_name)
    end

    it "optionally passes method argument values to the provided block" do
      method_an = nil
      DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name do |method_arg_name:|
        method_an = method_arg_name
      end
      expect(method_an).to eq(:bar)
    end

    it "executes the provided block once per child class" do
      executions = 0
      DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::ForMethodParser.new base_class, child_class, dsl_execution, :method_name do
        executions += 1
      end
      expect(executions).to eq(1)
    end
  end
end
