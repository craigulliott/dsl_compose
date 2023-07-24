# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Reader do
  let(:parser) { DSLCompose::Reader }
  let(:execution) {
    ChildClass.dsl_name :my_dsl_arg do
      method_name :my_dsl_method_arg
    end
  }

  before(:each) do
    create_class :BaseClass do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :arg_name, :symbol
        add_method :method_name do
          requires :arg_name, :symbol
        end
      end
    end

    # create a class hierachy with an ancestor who defined the DSL
    create_class :ChildClass, BaseClass
    create_class :GrandchildClass, ChildClass

    # create an unrelated class which does not have the expected DSL
    create_class :UnrelatedClass
  end

  describe :initialize do
    it "initializes without error" do
      expect {
        DSLCompose::Reader.new BaseClass, :dsl_name
      }.to_not raise_error
    end

    it "initializes without error when provided a class which has an ancestor where the DSL was originally defined" do
      expect {
        DSLCompose::Reader.new ChildClass, :dsl_name
      }.to_not raise_error
    end

    describe "if the DSL does not exist" do
      it "raises an error" do
        expect {
          DSLCompose::Reader.new ChildClass, :not_the_expected_dsl_name
        }.to raise_error DSLCompose::Reader::DSLNotFound
      end
    end

    describe "if neither the provided class or any of its ancestors have defined a DSL with the provided name" do
      it "raises an error" do
        expect {
          DSLCompose::Reader.new UnrelatedClass, :dsl_name
        }.to raise_error DSLCompose::Reader::DSLNotFound
      end
    end
  end

  describe :last_execution do
    describe "when provided a class which has a DSL defined and used on it" do
      let(:reader) { DSLCompose::Reader.new BaseClass, :dsl_name }

      let(:execution) {
        BaseClass.dsl_name :my_dsl_arg do
          method_name :my_dsl_method_arg
        end
      }

      before(:each) do
        execution
      end

      it "returns the expected execution" do
        expect(reader.last_execution).to eq execution
      end

      describe "when the DSL is used again" do
        let(:second_execution) {
          BaseClass.dsl_name :my_dsl_arg do
            method_name :my_dsl_method_arg
          end
        }

        before(:each) do
          second_execution
        end

        it "returns the last, most recent execution" do
          expect(reader.last_execution).to eq second_execution
        end
      end

      describe "when the DSL is used again but on a descendent of the provided class" do
        let(:second_execution) {
          ChildClass.dsl_name :my_dsl_arg do
            method_name :my_dsl_method_arg
          end
        }

        before(:each) do
          second_execution
        end

        it "returns the last, most recent execution on the provided class and ignores the execution on the child class" do
          expect(reader.last_execution).to eq execution
        end
      end
    end
  end

  describe :executions do
    describe "when a BaseClass has a DSL defined on it" do
      # note, the ChildClass used below is created at the top of this file
      # and already extends BaseClass (where the DSL is defined)

      describe "when a class extends this class and uses the DSL" do
        let(:execution) {
          ChildClass.dsl_name :my_dsl_arg do
            method_name :my_dsl_method_arg
          end
        }

        before(:each) do
          execution
        end

        it "a reader for the BaseClass returns no executions" do
          expect(DSLCompose::Reader.new(BaseClass, :dsl_name).executions).to eql []
        end

        it "a reader for this class returns only the exections which occured on it" do
          expect(DSLCompose::Reader.new(ChildClass, :dsl_name).executions).to eql [execution]
        end

        it "a reader for a new class which extends this class returns no executions" do
          expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).executions).to eql []
        end

        describe "when the DSL is used on the BaseClass" do
          let(:base_class_execution) {
            BaseClass.dsl_name :my_dsl_arg do
              method_name :my_dsl_method_arg
            end
          }

          before(:each) do
            base_class_execution
          end

          it "a reader for the BaseClass returns only the exections which occured on it" do
            expect(DSLCompose::Reader.new(BaseClass, :dsl_name).executions).to eql [base_class_execution]
          end

          it "a reader for this class returns only the exections which occured on it" do
            expect(DSLCompose::Reader.new(ChildClass, :dsl_name).executions).to eql [execution]
          end

          it "a reader for a new class which extends this class returns no executions" do
            expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).executions).to eql []
          end

          describe "when the DSL is used on another class which extends the original class" do
            let(:grandchild_class_execution) {
              GrandchildClass.dsl_name :my_dsl_arg do
                method_name :my_dsl_method_arg
              end
            }

            before(:each) do
              grandchild_class_execution
            end

            it "a reader for the BaseClass returns only the exections which occured on it" do
              expect(DSLCompose::Reader.new(BaseClass, :dsl_name).executions).to eql [base_class_execution]
            end

            it "a reader for this class returns only the exections which occured on it" do
              expect(DSLCompose::Reader.new(ChildClass, :dsl_name).executions).to eql [execution]
            end

            it "a reader for a new class which extends this class returns no executions" do
              expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).executions).to eql [grandchild_class_execution]
            end
          end
        end
      end
    end
  end

  describe :ancestor_executions do
    describe "when a BaseClass has a DSL defined on it" do
      # note, the ChildClass used below is created at the top of this file
      # and already extends BaseClass (where the DSL is defined)

      describe "when a class extends this class and uses the DSL" do
        let(:execution) {
          ChildClass.dsl_name :my_dsl_arg do
            method_name :my_dsl_method_arg
          end
        }

        before(:each) do
          execution
        end

        it "a reader for the BaseClass returns no executions" do
          expect(DSLCompose::Reader.new(BaseClass, :dsl_name).ancestor_executions).to eql []
        end

        it "a reader for this class returns no executions" do
          expect(DSLCompose::Reader.new(ChildClass, :dsl_name).ancestor_executions).to eql []
        end

        it "a reader for a new class which extends this class returns the execution which was performed on its direct ancestor" do
          expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).ancestor_executions).to eql [execution]
        end

        describe "when the DSL is used on the BaseClass" do
          let(:base_class_execution) {
            BaseClass.dsl_name :my_dsl_arg do
              method_name :my_dsl_method_arg
            end
          }

          before(:each) do
            base_class_execution
          end

          it "a reader for the BaseClass returns no executions" do
            expect(DSLCompose::Reader.new(BaseClass, :dsl_name).ancestor_executions).to eql []
          end

          it "a reader for this class returns the execution which was performed on its direct ancestor" do
            expect(DSLCompose::Reader.new(ChildClass, :dsl_name).ancestor_executions).to eql [base_class_execution]
          end

          it "a reader for a new class which extends this class returns the execution which was performed on its ancestors" do
            expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).ancestor_executions).to eql [execution, base_class_execution]
          end

          describe "when the DSL is used on another class which extends the original class" do
            let(:grandchild_class_execution) {
              GrandchildClass.dsl_name :my_dsl_arg do
                method_name :my_dsl_method_arg
              end
            }

            before(:each) do
              grandchild_class_execution
            end

            it "a reader for the BaseClass returns no executions" do
              expect(DSLCompose::Reader.new(BaseClass, :dsl_name).ancestor_executions).to eql []
            end

            it "a reader for this class returns the execution which was performed on its direct ancestor" do
              expect(DSLCompose::Reader.new(ChildClass, :dsl_name).ancestor_executions).to eql [base_class_execution]
            end

            it "a reader for a new class which extends this class returns the execution which was performed on its ancestors" do
              expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).ancestor_executions).to eql [execution, base_class_execution]
            end
          end
        end
      end
    end
  end

  describe :all_executions do
    describe "when a BaseClass has a DSL defined on it" do
      # note, the ChildClass used below is created at the top of this file
      # and already extends BaseClass (where the DSL is defined)

      describe "when a class extends this class and uses the DSL" do
        let(:execution) {
          ChildClass.dsl_name :my_dsl_arg do
            method_name :my_dsl_method_arg
          end
        }

        before(:each) do
          execution
        end

        it "a reader for the BaseClass returns no executions" do
          expect(DSLCompose::Reader.new(BaseClass, :dsl_name).all_executions).to eql []
        end

        it "a reader for this class returns the execution which occured on it" do
          expect(DSLCompose::Reader.new(ChildClass, :dsl_name).all_executions).to eql [execution]
        end

        it "a reader for a new class which extends this class returns the execution which occured on its direct ancestor" do
          expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).all_executions).to eql [execution]
        end

        describe "when the DSL is used on the BaseClass" do
          let(:base_class_execution) {
            BaseClass.dsl_name :my_dsl_arg do
              method_name :my_dsl_method_arg
            end
          }

          before(:each) do
            base_class_execution
          end

          it "a reader for the BaseClass returns the execution which occured on it" do
            expect(DSLCompose::Reader.new(BaseClass, :dsl_name).all_executions).to eql [base_class_execution]
          end

          it "a reader for this class returns the execution which occured on it and its direct ancestor" do
            expect(DSLCompose::Reader.new(ChildClass, :dsl_name).all_executions).to eql [execution, base_class_execution]
          end

          it "a reader for a new class which extends this class returns the execution which was performed on its ancestors" do
            expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).all_executions).to eql [execution, base_class_execution]
          end

          describe "when the DSL is used on another class which extends the original class" do
            let(:grandchild_class_execution) {
              GrandchildClass.dsl_name :my_dsl_arg do
                method_name :my_dsl_method_arg
              end
            }

            before(:each) do
              grandchild_class_execution
            end

            it "a reader for the BaseClass returns no executions" do
              expect(DSLCompose::Reader.new(BaseClass, :dsl_name).all_executions).to eql [base_class_execution]
            end

            it "a reader for this class returns the execution which occured on it and its direct ancestor" do
              expect(DSLCompose::Reader.new(ChildClass, :dsl_name).all_executions).to eql [execution, base_class_execution]
            end

            it "a reader for a new class which extends this class returns the execution which occured on it and its ancestors" do
              expect(DSLCompose::Reader.new(GrandchildClass, :dsl_name).all_executions).to eql [execution, base_class_execution, grandchild_class_execution]
            end
          end
        end
      end
    end
  end
end
