# frozen_string_literal: true

module DSLCompose
  class DSL
    module Errors
      class MethodAlreadyExists < StandardError
        def initialize method_name
          "The method #{method_name} already exists for this DSL."
        end
      end
    end
  end
end
