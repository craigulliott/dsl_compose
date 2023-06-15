# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Option
        module Errors
          class ValidationAlreadyExists < StandardError
            def initialize validation_name
              "The validation #{validation_name} has already been applied to this method option."
            end
          end
        end
      end
    end
  end
end
