# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Option
        module Errors
          class DescriptionAlreadyExists < StandardError
            def message
              "The description has already been set"
            end
          end
        end
      end
    end
  end
end
