# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::ReaderBase do
  describe "for a class with a DSL that includes an argument" do
    before(:each) do
      create_class :TestClass do
        include DSLCompose::Composer
        define_dsl :my_dsl do
          requires :required_option_name, :integer
        end
      end
    end

    describe "where than DSl is also used by the class" do
      before(:each) do
        TestClass.my_dsl 123
      end

      describe "for a DSL Reader which extends ReaderBase, exposes a valid convenience method and has a name which corresponds to the DSL" do
        before(:each) do
          create_class :MyDslDSLReader, DSLCompose::ReaderBase do
            def my_argument
              last_execution!.arguments.required_option_name
            end
          end
        end

        it "successfully parses the DSL from the class and returns the expected value from the convenience method" do
          expect(MyDslDSLReader.new(TestClass).my_argument).to eql(123)
        end
      end
    end
  end
end
