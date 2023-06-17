# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Interpreter do
  let(:dummy_class) { Class.new }
  let(:interpreter) { DSLCompose::Interpreter.new }
  let(:dsl) { DSLCompose::DSL.new :dsl_name, dummy_class }

  describe :initialize do
    it "initializes a new interpreter without raising any errors" do
      DSLCompose::Interpreter.new
    end
  end

  describe :executions do
    it "returns an empty object" do
      expect(interpreter.executions).to be_kind_of Hash
      expect(interpreter.executions).to be_empty
    end

    describe "when an excecution has occured" do
      before(:each) do
        interpreter.execute_dsl dummy_class, dsl
      end

      it "returns an object representing all executions" do
        expect(interpreter.executions).to be_kind_of Hash
        expect(interpreter.executions).to have_key(dummy_class)
        expect(interpreter.executions[dummy_class]).to be_kind_of Array
        expect(interpreter.executions[dummy_class].count).to eq 1
        expect(interpreter.executions[dummy_class].first).to be_kind_of DSLCompose::Interpreter::Execution
      end
    end
  end

  describe :class_executions do
    it "returns an empty array" do
      expect(interpreter.class_executions(dummy_class)).to be_kind_of Array
      expect(interpreter.class_executions(dummy_class)).to be_empty
    end

    describe "when an excecution has occured for a different class" do
      before(:each) do
        interpreter.execute_dsl Class.new, dsl
      end

      it "returns an empty array" do
        expect(interpreter.class_executions(dummy_class)).to be_kind_of Array
        expect(interpreter.class_executions(dummy_class)).to be_empty
      end

      describe "when an excecution has occured for this class" do
        before(:each) do
          interpreter.execute_dsl dummy_class, dsl
        end

        it "returns an array with the expected executions" do
          expect(interpreter.class_executions(dummy_class)).to be_kind_of Array
          expect(interpreter.class_executions(dummy_class).count).to eq 1
          expect(interpreter.class_executions(dummy_class).first).to be_kind_of DSLCompose::Interpreter::Execution
        end
      end
    end
  end
end
