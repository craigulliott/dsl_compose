# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser do
  describe :reader do
    before(:each) do
      create_class :BaseClass do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :method_arg_name, :symbol
            requires :common_method_arg_name, :symbol
          end
          add_method :common_method_name do
            requires :other_method_arg_name, :symbol
            requires :common_method_arg_name, :symbol
          end
        end
        define_dsl :other_dsl_name do
          add_method :other_method_name do
            # no args
          end
          add_method :common_method_name do
            requires :common_method_arg_name, :symbol
          end
        end
      end

      create_class :ChildClass1, BaseClass

      create_class :TestParser, DSLCompose::Parser
    end

    describe "where a DSL with a method, has the method called" do
      before(:each) do
        ChildClass1.dsl_name do
          method_name :foo, :bar
        end
      end

      it "returns the expected ExecutionReader object" do
        execution_reader = false
        # we add this check to ensure the code actually got to the expected point
        dsl_called = false

        TestParser.for_children_of BaseClass do |child_class:|
          for_dsl :dsl_name do |dsl_name:, reader:|
            dsl_called = true
            execution_reader = reader
          end
        end
        expect(dsl_called).to be true
        expect(execution_reader).to be_a DSLCompose::Reader::ExecutionReader
        expect(execution_reader.method_called?(:method_name)).to be true
      end
    end
  end
end
