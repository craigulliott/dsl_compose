# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::Parser do
  let(:parser) { DSLCompose::Parser }
  let(:base_class) do
    Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        requires :arg_name, :symbol
        add_method :method_name do
          requires :arg_name, :symbol
        end
      end
    end
  end

  describe :initialize do
    it "does not allow this class to be initialized" do
      expect {
        DSLCompose::Parser.new
      }.to raise_error DSLCompose::Parser::NotInitializable
    end
  end

  describe :for_children_of do
    describe "For a class which extends a class which has a DSL defined, and uses that defined DSL" do
      let(:child_class) {
        Class.new(base_class) do
          dsl_name :foo do
          end
        end
      }
      before(:each) {
        child_class
      }

      it "executes the provided block once per child class" do
        executions = 0
        parser.for_children_of base_class do
          executions += 1
        end
        expect(executions).to eq(1)
      end
    end
  end

  describe :rerun do
    describe "For a class which extends a class which has a DSL defined, and uses that defined DSL" do
      let(:child_class) {
        Class.new(base_class) do
          dsl_name :foo do
          end
        end
      }
      before(:each) {
        child_class
      }

      describe "after for_children_of has been called with a block" do
        let(:tracking_object) {
          {
            executions: 0
          }
        }

        before(:each) do
          tr_ob = tracking_object
          parser.for_children_of base_class do
            tr_ob[:executions] += 1
          end
        end

        it "executes the originally provided block once per child class" do
          expect(tracking_object[:executions]).to eq(1)
          parser.rerun
          expect(tracking_object[:executions]).to eq(2)
        end
      end
    end
  end
end
