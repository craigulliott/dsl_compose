# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      module Errors
        class OptionOrdering < StandardError
          def message
            "Required options can not be added after optional ones."
          end
        end
      end
    end
  end
end
