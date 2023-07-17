# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end
  end

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do
        end
      }.to_not raise_error
    end

    it "raises an error if the provided class does not have DSLCompose::Composer" do
      create_class :DifferentTestClass

      expect {
        DSLCompose::Parser::ForChildrenOfParser.new DifferentTestClass, false do
        end
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ClassDoesNotUseDSLComposeError
    end

    it "raises an error if a block is not provided to the initializer" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::NoBlockProvided
    end

    it "does not yield the provided block if there are no child classes" do
      executions = 0
      DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do |child_class:|
        executions += 1
      end
      expect(executions).to eq(0)
    end

    describe "For a class which extends a class which has a DSL defined, and uses that defined DSL" do
      before(:each) do
        create_class :ChildClass, BaseClass do
          dsl_name do
          end
        end
      end

      it "raises an error if the provided block has unexpected argument types" do
        expect {
          DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do |unexpected_argument|
          end
        }.to raise_error DSLCompose::Parser::ForChildrenOfParser::AllBlockParametersMustBeKeywordParametersError
      end

      it "raises an error if the provided block has unexpected keyword arguments" do
        expect {
          DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do |unexpected_keyword_argument:|
          end
        }.to raise_error ArgumentError
      end

      it "optionally passes the child class to the provided block" do
        cc = nil
        DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do |child_class:|
          cc = child_class
        end
        expect(cc).to be ChildClass
      end

      it "yields the provided block once per child class" do
        executions = 0
        DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do
          executions += 1
        end
        expect(executions).to eq(1)
      end
    end

    describe :for_dsl do
      before(:each) do
        create_class :ChildClass, BaseClass do
          dsl_name do
          end
        end
      end

      it "yields the provided block once per instance of the DSL with the provided name, per child class" do
        executions = 0
        DSLCompose::Parser::ForChildrenOfParser.new BaseClass, false do |child_class:|
          for_dsl :dsl_name do
            executions += 1
          end
        end
        expect(executions).to eq(1)
      end
    end
  end
end
