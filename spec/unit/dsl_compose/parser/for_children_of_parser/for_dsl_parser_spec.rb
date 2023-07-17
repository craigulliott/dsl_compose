# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :arg_name, :symbol
      end
    end

    create_class :ChildClass, BaseClass do
      dsl_name :foo do
      end
    end
  end

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true do
        end
      }.to_not raise_error
    end

    it "raises an error if the provided dsl name does not match any defined dsls" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :unexpected_dsl_name, true, true do
        end
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::DSLDoesNotExistError
    end

    it "accepts an array of dsl_names and initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, [:dsl_name], true, true do
        end
      }.to_not raise_error
    end

    it "raises an error if a block is not provided to the initializer" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::NoBlockProvided
    end

    it "raises an error if the provided block has unexpected argument types" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true do |unexpected_argument|
        end
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ForDSLParser::AllBlockParametersMustBeKeywordParametersError
    end

    it "raises an error if the provided block has unexpected keyword arguments" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true do |unexpected_keyword_argument:|
        end
      }.to raise_error ArgumentError
    end

    it "optionally passes the dsl_name to the provided block" do
      dn = nil
      DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true do |dsl_name:|
        dn = dsl_name
      end
      expect(dn).to eq(:dsl_name)
    end

    it "optionally passes dsl argument values to the provided block" do
      an = nil
      DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true do |arg_name:|
        an = arg_name
      end
      expect(an).to eq(:foo)
    end

    it "executes the provided block once per child class" do
      executions = 0
      DSLCompose::Parser::ForChildrenOfParser::ForDSLParser.new BaseClass, ChildClass, :dsl_name, true, true do
        executions += 1
      end
      expect(executions).to eq(1)
    end
  end
end
