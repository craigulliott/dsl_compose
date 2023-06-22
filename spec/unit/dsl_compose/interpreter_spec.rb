# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Interpreter do
  let(:dummy_class) { Class.new }
  let(:interpreter) { DSLCompose::Interpreter.new }
  let(:dsl) { DSLCompose::DSL.new :dsl_name, dummy_class }

  describe :initialize do
    it "initializes a new interpreter without raising any errors" do
      expect {
        DSLCompose::Interpreter.new
      }.to_not raise_error
    end
  end

  describe :executions do
    it "returns an empty object" do
      expect(interpreter.executions).to be_kind_of Array
      expect(interpreter.executions).to be_empty
    end

    describe "when an excecution has occured" do
      before(:each) do
        interpreter.execute_dsl dummy_class, dsl
      end

      it "returns an object representing all executions" do
        expect(interpreter.executions).to be_kind_of Array
        expect(interpreter.executions.count).to eq 1
        expect(interpreter.executions.first).to be_kind_of DSLCompose::Interpreter::Execution
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

  describe :dsl_executions do
    it "returns an empty array" do
      expect(interpreter.dsl_executions(dsl.name)).to be_kind_of Array
      expect(interpreter.dsl_executions(dsl.name)).to be_empty
    end

    describe "when an excecution has occured for a different dsl" do
      let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, dummy_class }

      before(:each) do
        interpreter.execute_dsl Class.new, different_dsl
      end

      it "returns an empty array" do
        expect(interpreter.dsl_executions(dsl.name)).to be_kind_of Array
        expect(interpreter.dsl_executions(dsl.name)).to be_empty
      end

      describe "when an excecution has occured for this dsl" do
        before(:each) do
          interpreter.execute_dsl dummy_class, dsl
        end

        it "returns an array with the expected executions" do
          expect(interpreter.dsl_executions(dsl.name)).to be_kind_of Array
          expect(interpreter.dsl_executions(dsl.name).count).to eq 1
          expect(interpreter.dsl_executions(dsl.name).first).to be_kind_of DSLCompose::Interpreter::Execution
        end
      end
    end
  end

  describe :to_h do
    it "returns an empty object" do
      expect(interpreter.to_h(dsl.name)).to eql({})
    end

    describe "when an excecution has occured for this class" do
      before(:each) do
        interpreter.execute_dsl dummy_class, dsl
      end

      it "returns a object, keyed by class, with keys for arguments and method calls" do
        expect(interpreter.to_h(dsl.name)).to eql(
          {
            dummy_class => {
              arguments: {},
              method_calls: {}
            }
          }
        )
      end
    end
  end

  describe :executions_by_class do
    it "returns an empty object" do
      expect(interpreter.executions_by_class).to eql({})
    end

    describe "when an excecution has occured for this class" do
      before(:each) do
        interpreter.execute_dsl dummy_class, dsl
      end

      it "returns a object, keyed by class, with keys for arguments and method calls" do
        expect(interpreter.executions_by_class).to eql(
          {
            dummy_class => {
              dsl_name: [{
                arguments: {},
                method_calls: {}
              }]
            }
          }
        )
      end
    end
  end
end
