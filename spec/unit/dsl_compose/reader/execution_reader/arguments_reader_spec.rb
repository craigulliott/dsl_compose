# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Reader::ExecutionReader::ArgumentsReader do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :my_dsl_argument, :symbol
        add_method :my_method do
          requires :my_dsl_method_argument, :symbol
        end
        add_unique_method :my_unique_method do
          requires :my_dsl_method_argument, :symbol
        end
      end
    end

    # create a class hierachy with an ancestor who defined the DSL
    create_class :ChildClass, BaseClass
    create_class :GrandchildClass, BaseClass

    # create an unrelated class which does not have the expected DSL
    create_class :UnrelatedClass
  end

  let(:execution) {
    ChildClass.dsl_name :my_dsl_value do
      my_method :my_dsl_method_value
      my_method :my_dsl_method_value
      my_unique_method :my_dsl_method_value
    end
  }

  let(:arguments) { execution.dsl.arguments }
  let(:argument_values) { execution.arguments }

  let(:arguments_reader) { DSLCompose::Reader::ExecutionReader::ArgumentsReader.new arguments, argument_values }

  describe :initialize do
    it "initializes without error" do
      expect {
        DSLCompose::Reader::ExecutionReader::ArgumentsReader.new arguments, argument_values
      }.to_not raise_error
    end
  end

  # this method does not exist on the class, the class is using `method_missing`
  # to satisfy this method call
  describe :my_dsl_argument do
    it "returns the expected value" do
      expect(arguments_reader.my_dsl_argument).to eql :my_dsl_value
    end
  end

  # this method does not exist on the class, and it is not an expected argument value
  describe :not_an_argument_name do
    it "returns the expected value" do
      expect {
        arguments_reader.not_an_argument_name
      }.to raise_error DSLCompose::DSL::Arguments::ArgumentDoesNotExistError
    end
  end
end
