# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      module Errors
        class InvalidDescription < StandardError
          def initialize description
            "The DSL method description #{description} is invalid, it must be of type string and have length greater than 0."
          end
        end
      end
    end
  end
end
