# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Option
        module Errors
          class InvalidType < StandardError
            def initialize type
              "Option type must be one of :integer, :boolean, :float, :string or :symbol but #{type} was provided"
            end
          end
        end
      end
    end
  end
end
