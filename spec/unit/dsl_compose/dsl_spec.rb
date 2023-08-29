# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL do
  before(:each) do
    create_class :TestClass
  end

  let(:dsl) { DSLCompose::DSL.new :dsl_name, TestClass }

  describe :initialize do
    it "initializes a new DSL without raising any errors" do
      expect {
        DSLCompose::DSL.new :dsl_name, TestClass
      }.to_not raise_error
    end

    it "raises an error if using a string instead of a symbol for the DSL name" do
      expect {
        DSLCompose::DSL.new "dsl_name", TestClass
      }.to raise_error(DSLCompose::DSL::InvalidNameError)
    end

    it "raises an error if passing an unexpected type for the DSL name" do
      expect {
        DSLCompose::DSL.new 123, TestClass
      }.to raise_error(DSLCompose::DSL::InvalidNameError)
    end
  end

  describe :evaluate_configuration_block do
    it "accepts a block which will be evaluated by the DSL's interpreter" do
      dsl.evaluate_configuration_block do
        description "This is a description of the DSL"
      end
    end

    it "raises an error if no block is provided" do
      expect {
        dsl.evaluate_configuration_block
      }.to raise_error(DSLCompose::DSL::NoBlockProvidedError)
    end
  end

  describe :set_description do
    it "sets a valid description without raising an error" do
      dsl.set_description "This is a description"
    end

    describe "when a description has already been set" do
      before(:each) do
        dsl.set_description "This is a description"
      end
      it "raises an error if you try and set the dsl description multiple times" do
        expect {
          dsl.set_description "This is a description"
        }.to raise_error(DSLCompose::DSL::DescriptionAlreadyExistsError)
      end
    end

    it "raises an error if you provide a symbol for the DSL description" do
      expect {
        dsl.set_description :invalid_description
      }.to raise_error(DSLCompose::DSL::InvalidDescriptionError)
    end

    it "raises an error if you provide an unexpected type for the DSL description" do
      expect {
        dsl.set_description 123
      }.to raise_error(DSLCompose::DSL::InvalidDescriptionError)
    end
  end

  describe :has_description do
    it "returns false if a description has not been set" do
      expect(dsl.has_description?).to eq(false)
    end

    describe "when a description has been set" do
      before(:each) do
        dsl.set_description "This is a description"
      end

      it "returns true if a description has been set" do
        expect(dsl.has_description?).to eq(true)
      end
    end
  end

  describe :set_namespace do
    it "sets a valid namespace without raising an error" do
      dsl.set_namespace :valid_namespace
    end

    describe "when a namespace has already been set" do
      before(:each) do
        dsl.set_namespace :valid_namespace
      end
      it "raises an error if you try and set the dsl namespace multiple times" do
        expect {
          dsl.set_namespace :valid_namespace
        }.to raise_error(DSLCompose::DSL::NamespaceAlreadyExistsError)
      end
    end

    it "raises an error if you provide a string for the DSL namespace" do
      expect {
        dsl.set_namespace "Invalid Namespace"
      }.to raise_error(DSLCompose::DSL::InvalidNamespaceError)
    end

    it "raises an error if you provide an unexpected type for the DSL namespace" do
      expect {
        dsl.set_namespace 123
      }.to raise_error(DSLCompose::DSL::InvalidNamespaceError)
    end
  end

  describe :has_namespace do
    it "returns false if a namespace has not been set" do
      expect(dsl.has_namespace?).to eq(false)
    end

    describe "when a namespace has been set" do
      before(:each) do
        dsl.set_namespace :valid_namespace
      end

      it "returns true if a namespace has been set" do
        expect(dsl.has_namespace?).to eq(true)
      end
    end
  end

  describe :set_title do
    it "sets a valid title without raising an error" do
      dsl.set_title "DSL Title"
    end

    describe "when a title has already been set" do
      before(:each) do
        dsl.set_title "DSL Title"
      end
      it "raises an error if you try and set the dsl title multiple times" do
        expect {
          dsl.set_title "DSL Title"
        }.to raise_error(DSLCompose::DSL::TitleAlreadyExistsError)
      end
    end

    it "raises an error if you provide a symbol for the DSL title" do
      expect {
        dsl.set_title :invalid_title
      }.to raise_error(DSLCompose::DSL::InvalidTitleError)
    end

    it "raises an error if you provide an unexpected type for the DSL title" do
      expect {
        dsl.set_title 123
      }.to raise_error(DSLCompose::DSL::InvalidTitleError)
    end
  end

  describe :has_title do
    it "returns false if a title has not been set" do
      expect(dsl.has_title?).to eq(false)
    end

    describe "when a title has been set" do
      before(:each) do
        dsl.set_title "DSL Title"
      end

      it "returns true if a title has been set" do
        expect(dsl.has_title?).to eq(true)
      end
    end
  end

  describe :add_method do
    it "adds a new method definition without raising an error" do
      dsl.add_method :method_name, true, true
    end

    describe "when a method of the same name already exists" do
      before(:each) do
        dsl.add_method :method_name, true, true
      end

      it "raises an error" do
        expect {
          dsl.add_method :method_name, true, true
        }.to raise_error(DSLCompose::DSL::MethodAlreadyExistsError)
      end
    end
  end

  describe :dsl_methods do
    it "returns an empty array if no methods have been added" do
      expect(dsl.dsl_methods).to be_a(Array)
      expect(dsl.dsl_methods.count).to eq(0)
    end

    describe "when methods have been added" do
      let(:new_method) { dsl.add_method :method_name, true, true }
      let(:another_new_method) { dsl.add_method :another_method_name, true, true }

      before(:each) do
        new_method
        another_new_method
      end

      it "returns an array of the expected DSLMethods" do
        expect(dsl.dsl_methods).to be_a(Array)
        expect(dsl.dsl_methods.count).to eq(2)
        expect(dsl.dsl_methods.first.name).to eq(:method_name)
        expect(dsl.dsl_methods.first).to be(new_method)
        expect(dsl.dsl_methods.last.name).to eq(:another_method_name)
        expect(dsl.dsl_methods.last).to be(another_new_method)
      end
    end
  end

  describe :has_methods? do
    it "returns false because no methods have been added" do
      expect(dsl.has_methods?).to be false
    end

    describe "when methods have been added" do
      let(:new_method) { dsl.add_method :method_name, true, true }

      before(:each) do
        new_method
      end

      it "returns true" do
        expect(dsl.has_methods?).to be true
      end
    end
  end

  describe :required_dsl_methods do
    it "returns an empty array" do
      expect(dsl.required_dsl_methods).to be_a(Array)
      expect(dsl.required_dsl_methods.count).to eq(0)
    end

    describe "when an optional method has been added" do
      before(:each) do
        dsl.add_method :optional_method_name, true, false
      end

      it "returns an empty array" do
        expect(dsl.required_dsl_methods).to be_a(Array)
        expect(dsl.required_dsl_methods.count).to eq(0)
      end

      describe "when required methods have been added" do
        let(:required_method) { dsl.add_method :required_method_name, true, true }
        let(:another_required_method) { dsl.add_method :another_required_method_name, true, true }

        before(:each) do
          required_method
          another_required_method
        end

        it "returns an array of only the required methods" do
          expect(dsl.required_dsl_methods).to be_a(Array)
          expect(dsl.required_dsl_methods.count).to eq(2)
          expect(dsl.required_dsl_methods.first.name).to eq(:required_method_name)
          expect(dsl.required_dsl_methods.first).to be(required_method)
          expect(dsl.required_dsl_methods.last.name).to eq(:another_required_method_name)
          expect(dsl.required_dsl_methods.last).to be(another_required_method)
        end
      end
    end
  end

  describe :optional_dsl_methods do
    it "returns an empty array" do
      expect(dsl.optional_dsl_methods).to be_a(Array)
      expect(dsl.optional_dsl_methods.count).to eq(0)
    end

    describe "when a required method has been added" do
      before(:each) do
        dsl.add_method :required_method_name, true, true
      end

      it "returns an empty array" do
        expect(dsl.optional_dsl_methods).to be_a(Array)
        expect(dsl.optional_dsl_methods.count).to eq(0)
      end

      describe "when optional methods have been added" do
        let(:optional_method) { dsl.add_method :optional_method_name, true, false }
        let(:another_optional_method) { dsl.add_method :another_optional_method_name, true, false }

        before(:each) do
          optional_method
          another_optional_method
        end

        it "returns an array of only the optional methods" do
          expect(dsl.optional_dsl_methods).to be_a(Array)
          expect(dsl.optional_dsl_methods.count).to eq(2)
          expect(dsl.optional_dsl_methods.first.name).to eq(:optional_method_name)
          expect(dsl.optional_dsl_methods.first).to be(optional_method)
          expect(dsl.optional_dsl_methods.last.name).to eq(:another_optional_method_name)
          expect(dsl.optional_dsl_methods.last).to be(another_optional_method)
        end
      end
    end
  end

  describe :has_required_methods? do
    it "returns false" do
      expect(dsl.has_required_methods?).to be false
    end

    describe "when an optional method has been added" do
      before(:each) do
        dsl.add_method :optional_method_name, true, false
      end

      it "returns false" do
        expect(dsl.has_required_methods?).to be false
      end

      describe "when required methods have been added" do
        let(:required_method) { dsl.add_method :required_method_name, true, true }
        let(:another_required_method) { dsl.add_method :another_required_method_name, true, true }

        before(:each) do
          required_method
          another_required_method
        end

        it "returns true" do
          expect(dsl.has_required_methods?).to be true
        end
      end
    end
  end

  describe :has_optional_methods? do
    it "returns false" do
      expect(dsl.has_optional_methods?).to be false
    end

    describe "when a required method has been added" do
      before(:each) do
        dsl.add_method :required_method_name, true, true
      end

      it "returns false" do
        expect(dsl.has_optional_methods?).to be false
      end

      describe "when optional methods have been added" do
        let(:optional_method) { dsl.add_method :optional_method_name, true, false }
        let(:another_optional_method) { dsl.add_method :another_optional_method_name, true, false }

        before(:each) do
          optional_method
          another_optional_method
        end

        it "returns true" do
          expect(dsl.has_optional_methods?).to be true
        end
      end
    end
  end

  describe :dsl_method do
    it "raises an error if the requested DSL method does not exist" do
      expect {
        dsl.dsl_method :a_method_which_does_not_exist
      }.to raise_error(DSLCompose::DSL::MethodDoesNotExistError)
    end

    describe "when a method with the requested name has been added" do
      let(:new_method) { dsl.add_method :method_name, true, true }

      before(:each) do
        new_method
      end

      it "returns the expected DSLMethod" do
        expect(dsl.dsl_method(:method_name)).to be(new_method)
      end
    end
  end

  describe :has_dsl_method? do
    it "returns `false`" do
      expect(dsl.has_dsl_method?(:a_method_which_does_not_exist)).to eq(false)
    end

    describe "when a method with the requested name has been added" do
      let(:new_method) { dsl.add_method :method_name, true, true }

      before(:each) do
        new_method
      end

      it "returns true" do
        expect(dsl.has_dsl_method?(:method_name)).to eq(true)
      end
    end
  end
end
