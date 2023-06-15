# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      module Errors
        class OptionAlreadyExists < StandardError
          def initialize option_name
            "The option #{option_name} already exists for this DSL method."
          end
        end
      end
    end
  end
end
