# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Interpreter do
  before(:each) do
    create_class :TestClass
  end

  let(:interpreter) { DSLCompose::Interpreter.new }
  let(:dsl) { DSLCompose::DSL.new :dsl_name, TestClass }

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
        interpreter.execute_dsl TestClass, dsl
      end

      it "returns an object representing all executions" do
        expect(interpreter.executions).to be_kind_of Array
        expect(interpreter.executions.count).to eq 1
        expect(interpreter.executions.first).to be_kind_of DSLCompose::Interpreter::Execution
      end
    end
  end

  describe :parser_usage_notes do
    it "returns an empty array" do
      expect(interpreter.parser_usage_notes(TestClass)).to eql([])
    end

    describe "when a parser usage note has been added" do
      before(:each) do
        interpreter.add_parser_usage_note TestClass, "a note about this parser"
      end

      it "returns an array whch contains the expected parser note" do
        expect(interpreter.parser_usage_notes(TestClass)).to eql(["a note about this parser"])
      end
    end
  end

  describe :add_parser_usage_note do
    it "adds a parser note" do
      expect(interpreter.parser_usage_notes(TestClass)).to eql([])
      interpreter.add_parser_usage_note TestClass, "a note about this parser"
      expect(interpreter.parser_usage_notes(TestClass)).to eql(["a note about this parser"])
    end
  end

  describe :class_executions do
    it "returns an empty array" do
      expect(interpreter.class_executions(TestClass)).to be_kind_of Array
      expect(interpreter.class_executions(TestClass)).to be_empty
    end

    describe "when an excecution has occured for a different class" do
      before(:each) do
        create_class :DifferentTestClass

        interpreter.execute_dsl DifferentTestClass, dsl
      end

      it "returns an empty array" do
        expect(interpreter.class_executions(TestClass)).to be_kind_of Array
        expect(interpreter.class_executions(TestClass)).to be_empty
      end

      describe "when an excecution has occured for this class" do
        before(:each) do
          interpreter.execute_dsl TestClass, dsl
        end

        it "returns an array with the expected executions" do
          expect(interpreter.class_executions(TestClass)).to be_kind_of Array
          expect(interpreter.class_executions(TestClass).count).to eq 1
          expect(interpreter.class_executions(TestClass).first).to be_kind_of DSLCompose::Interpreter::Execution
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
      let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

      before(:each) do
        create_class :DifferentTestClass

        interpreter.execute_dsl DifferentTestClass, different_dsl
      end

      it "returns an empty array" do
        expect(interpreter.dsl_executions(dsl.name)).to be_kind_of Array
        expect(interpreter.dsl_executions(dsl.name)).to be_empty
      end

      describe "when an excecution has occured for this dsl" do
        before(:each) do
          interpreter.execute_dsl TestClass, dsl
        end

        it "returns an array with the expected executions" do
          expect(interpreter.dsl_executions(dsl.name)).to be_kind_of Array
          expect(interpreter.dsl_executions(dsl.name).count).to eq 1
          expect(interpreter.dsl_executions(dsl.name).first).to be_kind_of DSLCompose::Interpreter::Execution
        end
      end
    end
  end

  describe :class_dsl_executions do
    describe "when on_current_class is true and on_ancestor_class is true" do
      it "returns an empty array" do
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true)).to be_kind_of Array
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true)).to be_empty
      end

      describe "when an excecution has occured for a different dsl" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

        before(:each) do
          create_class :DifferentTestClass

          interpreter.execute_dsl DifferentTestClass, different_dsl
        end

        it "returns an empty array" do
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true)).to be_kind_of Array
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true)).to be_empty
        end

        describe "when an excecution has occured for this dsl" do
          before(:each) do
            interpreter.execute_dsl TestClass, dsl
          end

          it "returns an array with the expected executions" do
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true)).to be_kind_of Array
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true).count).to eq 1
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true).first).to be_kind_of DSLCompose::Interpreter::Execution
          end

          describe "when an excecution has occured for this dsl on a class which is an ansestor of the provided class" do
            before(:each) do
              create_class :ChildClass, TestClass
            end

            it "returns an array with the expected executions" do
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true).count).to eq 1
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true).first).to be_kind_of DSLCompose::Interpreter::Execution
            end
          end
        end
      end
    end

    describe "when on_current_class is false and on_ancestor_class is true" do
      it "returns an empty array" do
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true)).to be_kind_of Array
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true)).to be_empty
      end

      describe "when an excecution has occured for a different dsl" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

        before(:each) do
          create_class :DifferentTestClass

          interpreter.execute_dsl DifferentTestClass, different_dsl
        end

        it "returns an empty array" do
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true)).to be_kind_of Array
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true)).to be_empty
        end

        describe "when an excecution has occured for this dsl" do
          before(:each) do
            interpreter.execute_dsl TestClass, dsl
          end

          it "returns an empty array" do
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true)).to be_kind_of Array
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true)).to be_empty
          end

          describe "when an excecution has occured for this dsl on a class which is an ansestor of the provided class" do
            before(:each) do
              create_class :ChildClass, TestClass
            end

            it "returns an array with the expected executions" do
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true).count).to eq 1
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true).first).to be_kind_of DSLCompose::Interpreter::Execution
            end
          end
        end
      end
    end

    describe "when on_current_class is true and on_ancestor_class is false" do
      it "returns an empty array" do
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false)).to be_kind_of Array
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false)).to be_empty
      end

      describe "when an excecution has occured for a different dsl" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

        before(:each) do
          create_class :DifferentTestClass

          interpreter.execute_dsl DifferentTestClass, different_dsl
        end

        it "returns an empty array" do
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false)).to be_kind_of Array
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false)).to be_empty
        end

        describe "when an excecution has occured for this dsl" do
          before(:each) do
            interpreter.execute_dsl TestClass, dsl
          end

          it "returns an array with the expected executions" do
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false)).to be_kind_of Array
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false).count).to eq 1
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false).first).to be_kind_of DSLCompose::Interpreter::Execution
          end

          describe "when an excecution has occured for this dsl on a class which is an ansestor of the provided class" do
            before(:each) do
              create_class :ChildClass, TestClass
            end

            it "returns an empty array" do
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, true, false)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, true, false)).to be_empty
            end
          end
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
        interpreter.execute_dsl TestClass, dsl
      end

      it "returns a object, keyed by class, with keys for arguments and method calls" do
        expect(interpreter.to_h(dsl.name)).to eql(
          {
            TestClass => {
              arguments: {},
              method_calls: {}
            }
          }
        )
      end
    end
  end

  describe :clear do
    it "does not throw an error" do
      expect {
        interpreter.clear
      }.to_not raise_error
    end

    describe "when an excecution has occured for this class" do
      before(:each) do
        interpreter.execute_dsl TestClass, dsl
      end

      it "does not throw an error" do
        expect {
          interpreter.clear
        }.to_not raise_error
      end

      it "clears the executions (evidenced by to_h returning an empty object)" do
        expect(interpreter.to_h(dsl.name)).to_not eql({})
        interpreter.clear
        expect(interpreter.to_h(dsl.name)).to eql({})
      end
    end

    describe "when a parser_usage_note has been added for this class" do
      before(:each) do
        interpreter.add_parser_usage_note TestClass, "a note"
      end

      it "does not throw an error" do
        expect {
          interpreter.clear
        }.to_not raise_error
      end

      it "clears the parser_usage_notes (evidenced by parser_usage_notes returning an empty array)" do
        expect(interpreter.parser_usage_notes(TestClass)).to eql(["a note"])
        interpreter.clear
        expect(interpreter.parser_usage_notes(TestClass)).to eql([])
      end
    end
  end

  describe :executions_by_class do
    it "returns an empty object" do
      expect(interpreter.executions_by_class).to eql({})
    end

    describe "when an excecution has occured for this class" do
      before(:each) do
        interpreter.execute_dsl TestClass, dsl
      end

      it "returns a object, keyed by class, with keys for arguments and method calls" do
        expect(interpreter.executions_by_class).to eql(
          {
            TestClass => {
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
