# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::Arguments::Argument do
  let(:dummy_class) { Class.new { include DSLCompose::Composer } }

  it "accepts and returns a description when requested" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          requires :required_argument, :integer do
            description "This is an argument description"
          end
        end
      end
    end

    expect(DSLCompose::DSLs.class_dsl(klass, :dsl_name).dsl_methods.first.arguments.arguments.first.description).to eq("This is an argument description")
  end

  it "raises an error if you try and set the DSL description multiple times" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_argument, :integer do
              description "This is an argument description"
              description "This is another argument description"
            end
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::Arguments::Argument::DescriptionAlreadyExistsError)
  end

  it "raises an error if you provide a symbol for the method description" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_argument, :integer do
              description :invalid_description
            end
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::Arguments::Argument::InvalidDescriptionError)
  end

  it "raises an error if you provide an unexpected type for the method description" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            requires :required_argument, :integer do
              description 123
            end
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::Arguments::Argument::InvalidDescriptionError)
  end
end