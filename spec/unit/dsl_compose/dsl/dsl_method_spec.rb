# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod do
  let(:dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, true, true }

  describe :initialize do
    it "initializes a new DSLMethod without raising any errors" do
      expect {
        DSLCompose::DSL::DSLMethod.new :method_name, true, true
      }.to_not raise_error
    end

    it "raises an error if using a string instead of a symbol for the DSLMethod name" do
      expect {
        DSLCompose::DSL::DSLMethod.new "method_name", true, true
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidNameError)
    end

    it "raises an error if using a reserved name which would collide with internal methods" do
      expect {
        DSLCompose::DSL::DSLMethod.new :class, true, true
      }.to raise_error(DSLCompose::DSL::DSLMethod::MethodNameIsReservedError)
    end

    it "raises an error if passing an unexpected type for the DSLMethod name" do
      expect {
        DSLCompose::DSL::DSLMethod.new 123, true, true
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidNameError)
    end
  end

  describe :set_description do
    it "sets a valid description without raising an error" do
      dsl_method.set_description "This is a description"
    end

    describe "when a description has already been set" do
      before(:each) do
        dsl_method.set_description "This is a description"
      end
      it "raises an error if you try and set the dsl description multiple times" do
        expect {
          dsl_method.set_description "This is a description"
        }.to raise_error(DSLCompose::DSL::DSLMethod::DescriptionAlreadyExistsError)
      end
    end

    it "raises an error if you provide a symbol for the DSL description" do
      expect {
        dsl_method.set_description :invalid_description
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
    end

    it "raises an error if you provide an unexpected type for the DSL description" do
      expect {
        dsl_method.set_description 123
      }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
    end
  end

  describe :has_description do
    it "returns false if a description has not been set" do
      expect(dsl_method.has_description?).to eq(false)
    end

    describe "when a description has been set" do
      before(:each) do
        dsl_method.set_description "This is a description"
      end

      it "returns true if a description has been set" do
        expect(dsl_method.has_description?).to eq(true)
      end
    end
  end

  describe :unique? do
    it "returns true for unique DSLMethods" do
      expect(dsl_method.unique?).to be true
    end

    let(:nonunique_dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, false, true }

    it "returns false for unique DSLMethods" do
      expect(nonunique_dsl_method.unique?).to be false
    end
  end

  describe :required? do
    it "returns true for required DSLMethods" do
      expect(dsl_method.required?).to be true
    end

    let(:optional_dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, true, false }

    it "returns false for required DSLMethods" do
      expect(optional_dsl_method.required?).to be false
    end
  end

  describe :optional? do
    it "returns false for required DSLMethods" do
      expect(dsl_method.optional?).to be false
    end

    let(:optional_dsl_method) { DSLCompose::DSL::DSLMethod.new :method_name, true, false }

    it "returns true for required DSLMethods" do
      expect(optional_dsl_method.optional?).to be true
    end
  end
end
