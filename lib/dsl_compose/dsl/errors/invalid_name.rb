# frozen_string_literal: true

module DSLCompose
  class DSL
    module Errors

      class InvalidName < StandardError
        def initialize dsl_name
          "The DSL name #{dsl_name} is invalid, it must be of type symbol."
        end
      end

    end
  end
end