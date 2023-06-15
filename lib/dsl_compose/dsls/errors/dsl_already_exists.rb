# frozen_string_literal: true

module DSLCompose
  module DSLs
    module Errors

      class DSLAlreadyExists < StandardError
        def initialize dsl_name
          super "A DSL with the name #{dsl_name} already exists"
        end
      end

    end
  end
end