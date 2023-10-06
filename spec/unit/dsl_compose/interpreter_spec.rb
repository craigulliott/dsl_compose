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
        interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
      end

      it "returns an object representing all executions" do
        expect(interpreter.executions).to be_kind_of Array
        expect(interpreter.executions.count).to eq 1
        expect(interpreter.executions.first).to be_kind_of DSLCompose::Interpreter::Execution
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

  describe :execute_dsl do
    # the parser execution is tested only through the integration tests
  end

  describe :class_executions do
    it "returns an empty array" do
      expect(interpreter.class_executions(TestClass)).to be_kind_of Array
      expect(interpreter.class_executions(TestClass)).to be_empty
    end

    describe "when an excecution has occured for a different class" do
      before(:each) do
        create_class :DifferentTestClass

        interpreter.execute_dsl DifferentTestClass, dsl, "%called_from string - line and line number%"
      end

      it "returns an empty array" do
        expect(interpreter.class_executions(TestClass)).to be_kind_of Array
        expect(interpreter.class_executions(TestClass)).to be_empty
      end

      describe "when an excecution has occured for this class" do
        before(:each) do
          interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
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

        interpreter.execute_dsl DifferentTestClass, different_dsl, "%called_from string - line and line number%"
      end

      it "returns an empty array" do
        expect(interpreter.dsl_executions(dsl.name)).to be_kind_of Array
        expect(interpreter.dsl_executions(dsl.name)).to be_empty
      end

      describe "when an excecution has occured for this dsl" do
        before(:each) do
          interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
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
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false)).to be_kind_of Array
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false)).to be_empty
      end

      describe "when an excecution has occured for a different dsl" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

        before(:each) do
          create_class :DifferentTestClass

          interpreter.execute_dsl DifferentTestClass, different_dsl, "%called_from string - line and line number%"
        end

        it "returns an empty array" do
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false)).to be_kind_of Array
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false)).to be_empty
        end

        describe "when an excecution has occured for this dsl" do
          before(:each) do
            interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
          end

          it "returns an array with the expected executions" do
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false)).to be_kind_of Array
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false).count).to eq 1
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false).first).to be_kind_of DSLCompose::Interpreter::Execution
          end

          describe "when an excecution has occured for this dsl on a class which is an ancestor of the provided class" do
            before(:each) do
              create_class :ChildClass, TestClass
            end

            it "returns an array with the expected executions" do
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true, false)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true, false).count).to eq 1
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true, false).first).to be_kind_of DSLCompose::Interpreter::Execution
            end
          end

          describe "when another excecution has occured for this dsl" do
            let(:most_recent_execution) { interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%" }

            before(:each) do
              most_recent_execution
            end

            it "returns an array with the expected executions" do
              expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false).count).to eq 2
              expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false).first).to be_kind_of DSLCompose::Interpreter::Execution
              expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, false).last).to be_kind_of DSLCompose::Interpreter::Execution
            end

            describe "when first_use_only is true" do
              it "returns the most recent execution only" do
                expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, true)).to be_kind_of Array
                expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, true).count).to eq 1
                expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, true, true).first).to be most_recent_execution
              end
            end
          end
        end
      end
    end

    describe "when on_current_class is false and on_ancestor_class is true" do
      it "returns an empty array" do
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true, false)).to be_kind_of Array
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true, false)).to be_empty
      end

      describe "when an excecution has occured for a different dsl" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

        before(:each) do
          create_class :DifferentTestClass

          interpreter.execute_dsl DifferentTestClass, different_dsl, "%called_from string - line and line number%"
        end

        it "returns an empty array" do
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true, false)).to be_kind_of Array
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true, false)).to be_empty
        end

        describe "when an excecution has occured for this dsl" do
          before(:each) do
            interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
          end

          it "returns an empty array" do
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true, false)).to be_kind_of Array
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, false, true, false)).to be_empty
          end

          describe "when an excecution has occured for this dsl on a class which is an ancestor of the provided class" do
            before(:each) do
              create_class :ChildClass, TestClass
            end

            it "returns an array with the expected executions" do
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true, false)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true, false).count).to eq 1
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, false, true, false).first).to be_kind_of DSLCompose::Interpreter::Execution
            end
          end
        end
      end
    end

    describe "when on_current_class is true and on_ancestor_class is false" do
      it "returns an empty array" do
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false)).to be_kind_of Array
        expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false)).to be_empty
      end

      describe "when an excecution has occured for a different dsl" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }

        before(:each) do
          create_class :DifferentTestClass

          interpreter.execute_dsl DifferentTestClass, different_dsl, "%called_from string - line and line number%"
        end

        it "returns an empty array" do
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false)).to be_kind_of Array
          expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false)).to be_empty
        end

        describe "when an excecution has occured for this dsl" do
          before(:each) do
            interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
          end

          it "returns an array with the expected executions" do
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false)).to be_kind_of Array
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false).count).to eq 1
            expect(interpreter.class_dsl_executions(TestClass, dsl.name, true, false, false).first).to be_kind_of DSLCompose::Interpreter::Execution
          end

          describe "when an excecution has occured for this dsl on a class which is an ancestor of the provided class" do
            before(:each) do
              create_class :ChildClass, TestClass
            end

            it "returns an empty array" do
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, true, false, false)).to be_kind_of Array
              expect(interpreter.class_dsl_executions(ChildClass, dsl.name, true, false, false)).to be_empty
            end
          end
        end
      end
    end
  end

  describe :get_last_dsl_execution do
    describe "when there is a single dsl execution on the provided class" do
      let(:execution) { interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%" }

      before(:each) do
        execution
      end

      it "returns the execution" do
        expect(interpreter.get_last_dsl_execution(TestClass, dsl.name)).to eq(execution)
      end

      describe "when there is a second dsl execution on the provided class" do
        let(:second_execution) { interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%" }

        before(:each) do
          second_execution
        end

        it "returns the most recent (second) execution" do
          expect(interpreter.get_last_dsl_execution(TestClass, dsl.name)).to eq(second_execution)
        end
      end

      describe "when there is a second execution from a different DSL on the provided class" do
        let(:different_dsl) { DSLCompose::DSL.new :different_dsl_name, TestClass }
        let(:second_execution) { interpreter.execute_dsl TestClass, different_dsl, "%called_from string - line and line number%" }

        before(:each) do
          second_execution
        end

        it "returns the expected execution" do
          expect(interpreter.get_last_dsl_execution(TestClass, dsl.name)).to eq(execution)
        end

        describe "when the provided class is an ancestor of the class which the DSL was executed on" do
          before(:each) do
            create_class :ChildClass, TestClass
          end

          it "returns the expected execution" do
            expect(interpreter.get_last_dsl_execution(ChildClass, dsl.name)).to eq(execution)
          end

          describe "when the child class has it's own execution of the DSL" do
            let(:child_class_execution) { interpreter.execute_dsl ChildClass, dsl, "%called_from string - line and line number%" }

            before(:each) do
              child_class_execution
            end

            it "returns the expected execution" do
              expect(interpreter.get_last_dsl_execution(ChildClass, dsl.name)).to eq(child_class_execution)
            end
          end
        end
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
        interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
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

  describe :to_h do
    it "returns an empty object" do
      expect(interpreter.to_h(dsl.name)).to eql({})
    end

    describe "when an excecution has occured for this class" do
      before(:each) do
        interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
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

  describe :executions_by_class do
    it "returns an empty object" do
      expect(interpreter.executions_by_class).to eql({})
    end

    describe "when an excecution has occured for this class" do
      before(:each) do
        interpreter.execute_dsl TestClass, dsl, "%called_from string - line and line number%"
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
