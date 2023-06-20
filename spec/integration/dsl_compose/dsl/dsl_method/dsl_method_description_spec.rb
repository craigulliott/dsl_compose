# frozen_string_literal: true

require "spec_helper"

RSpec.describe DSLCompose::DSL::DSLMethod do
  let(:dummy_class) { Class.new { include DSLCompose::Composer } }

  it "accepts and returns a description when requested" do
    klass = Class.new do
      include DSLCompose::Composer
      define_dsl :dsl_name do
        add_method :method_name do
          description "This is a method description"
        end
      end
    end

    expect(DSLCompose::DSLs.class_dsl(klass, :dsl_name).dsl_methods.first.description).to eq("This is a method description")
  end

  it "raises an error if you try and set the DSL description multiple times" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            description "This is a method description"
            description "This is another method description"
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::DescriptionAlreadyExistsError)
  end

  it "raises an error if you provide a symbol for the method description" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            description :invalid_description
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
  end

  it "raises an error if you provide an unexpected type for the method description" do
    expect {
      Class.new do
        include DSLCompose::Composer
        define_dsl :dsl_name do
          add_method :method_name do
            description 123
          end
        end
      end
    }.to raise_error(DSLCompose::DSL::DSLMethod::InvalidDescriptionError)
  end
end
