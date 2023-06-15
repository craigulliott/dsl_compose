# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Option
        module Errors
          class InvalidName < StandardError
            def initialize option_name
              "The option name #{option_name} is invalid, it must be of type symbol."
            end
          end
        end
      end
    end
  end
end
