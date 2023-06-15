# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      module Errors

        class InvalidName < StandardError
          def initialize method_name
            "The method #{method_name} is invalid, it must be of type symbol."
          end
        end

      end
    end
  end
end