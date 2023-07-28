# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser::ForChildrenOfParser::ForDSLParser do
  describe :method_called? do
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

    describe "where a DSL with a method is called, but the method is not called" do
      before(:each) do
        ChildClass1.dsl_name do
        end
      end

      it "returns false because the method has not been called" do
        was_method_called = false
        # we add this check to ensure the code actually got to the expected point
        dsl_called = false

        TestParser.for_children_of BaseClass do |child_class:|
          for_dsl :dsl_name do |dsl_name:|
            dsl_called = true
            was_method_called = method_called? :method_name
          end
        end
        expect(dsl_called).to be true
        expect(was_method_called).to be false
      end

      it "raises an error if the provided method name does not exist for the DSL" do
        expect {
          TestParser.for_children_of BaseClass do |child_class:|
            for_dsl :dsl_name do |dsl_name:|
              method_called? :not_a_real_method
            end
          end
        }.to raise_error DSLCompose::DSL::MethodDoesNotExistError
      end
    end

    describe "where a DSL with a method, has the method called" do
      before(:each) do
        ChildClass1.dsl_name do
          method_name :foo, :bar
        end
      end

      it "returns true" do
        was_method_called = false
        # we add this check to ensure the code actually got to the expected point
        dsl_called = false

        TestParser.for_children_of BaseClass do |child_class:|
          for_dsl :dsl_name do |dsl_name:|
            dsl_called = true
            was_method_called = method_called? :method_name
          end
        end
        expect(dsl_called).to be true
        expect(was_method_called).to be true
      end
    end
  end
end
