# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Reader::ExecutionReader do
  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :my_dsl_argument, :symbol
        add_method :my_method do
          requires :my_dsl_method_argument, :symbol
        end
        add_method :unused_method
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

  let(:reader) { DSLCompose::Reader::ExecutionReader.new execution }

  describe :initialize do
    it "initializes without error" do
      expect {
        DSLCompose::Reader::ExecutionReader.new execution
      }.to_not raise_error
    end
  end

  describe :execution do
    it "returns the expected execution" do
      expect(reader.execution).to eq(execution)
    end
  end

  describe :arguments do
    it "returns an ArgsReader object" do
      expect(reader.arguments).to be_a DSLCompose::Reader::ExecutionReader::ArgumentsReader
    end

    it "returns an ArgsReader object which allows access to the expected arguments" do
      expect(reader.arguments.my_dsl_argument).to eql :my_dsl_value
    end
  end

  describe :method_called? do
    it "returns true for methods which have been used" do
      expect(reader.method_called?(:my_method)).to be true
    end

    it "returns false for methods which have not been used" do
      expect(reader.method_called?(:unused_method)).to be false
    end

    it "raises an error for methods which don't exist" do
      expect {
        reader.method_called?(:not_a_real_method)
      }.to raise_error DSLCompose::Reader::ExecutionReader::MethodDoesNotExist
    end
  end

  # this method does not exist on the class, the class is using `method_missing`
  # to satisfy this method call
  describe :my_method do
    it "returns an array of ArgsReader objects" do
      expect(reader.my_method).to be_a Array
      expect(reader.my_method.count).to eq 2
      expect(reader.my_method[0]).to be_a DSLCompose::Reader::ExecutionReader::ArgumentsReader
      expect(reader.my_method[1]).to be_a DSLCompose::Reader::ExecutionReader::ArgumentsReader
    end

    it "returns an array of ArgsReader objects which allows access to the expected arguments" do
      expect(reader.my_method[0].my_dsl_method_argument).to eql :my_dsl_method_value
      expect(reader.my_method[1].my_dsl_method_argument).to eql :my_dsl_method_value
    end
  end

  # this method does not exist on the class, the class is using `method_missing`
  # to satisfy this method call
  describe :my_unique_method do
    it "returns an ArgsReader object" do
      expect(reader.my_unique_method).to be_a DSLCompose::Reader::ExecutionReader::ArgumentsReader
    end

    it "returns an ArgsReader object which allows access to the expected arguments" do
      expect(reader.my_unique_method.my_dsl_method_argument).to eql :my_dsl_method_value
    end
  end
end
