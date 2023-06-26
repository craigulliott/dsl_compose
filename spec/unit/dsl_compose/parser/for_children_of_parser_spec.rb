# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser do
  let(:base_class) do
    Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name
    end
  end

  describe :initialize do
    it "initializes the class without error" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser.new base_class do
        end
      }.to_not raise_error
    end

    it "raises an error if the provided class does not have DSLCompose::Composer" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser.new Class.new do
        end
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::ClassDoesNotUseDSLComposeError
    end

    it "raises an error if a block is not provided to the initializer" do
      expect {
        DSLCompose::Parser::ForChildrenOfParser.new base_class
      }.to raise_error DSLCompose::Parser::ForChildrenOfParser::NoBlockProvided
    end

    it "does not yield the provided block if there are no child classes" do
      executions = 0
      DSLCompose::Parser::ForChildrenOfParser.new base_class do |child_class:|
        executions += 1
      end
      expect(executions).to eq(0)
    end

    describe "For a class which extends a class which has a DSL defined, and uses that defined DSL" do
      let(:child_class) {
        Class.new(base_class) do
          dsl_name do
          end
        end
      }
      before(:each) {
        child_class
      }

      it "raises an error if the provided block has unexpected argument types" do
        expect {
          DSLCompose::Parser::ForChildrenOfParser.new base_class do |unexpected_argument|
          end
        }.to raise_error DSLCompose::Parser::ForChildrenOfParser::AllBlockParametersMustBeKeywordParametersError
      end

      it "raises an error if the provided block has unexpected keyword arguments" do
        expect {
          DSLCompose::Parser::ForChildrenOfParser.new base_class do |unexpected_keyword_argument:|
          end
        }.to raise_error ArgumentError
      end

      it "optionally passes the child class to the provided block" do
        cc = nil
        DSLCompose::Parser::ForChildrenOfParser.new base_class do |child_class:|
          cc = child_class
        end
        expect(cc).to be child_class
      end

      it "yields the provided block once per child class" do
        executions = 0
        DSLCompose::Parser::ForChildrenOfParser.new base_class do
          executions += 1
        end
        expect(executions).to eq(1)
      end
    end

    describe :for_dsl do
      let(:child_class) {
        Class.new(base_class) do
          dsl_name do
          end
        end
      }
      before(:each) {
        child_class
      }

      it "yields the provided block once per instance of the DSL with the provided name, per child class" do
        executions = 0
        DSLCompose::Parser::ForChildrenOfParser.new base_class do |child_class:|
          for_dsl :dsl_name do
            executions += 1
          end
        end
        expect(executions).to eq(1)
      end
    end
  end
end
