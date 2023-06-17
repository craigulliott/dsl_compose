# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class FormatValidation
          def initialize regex
            @regex = regex
          end

          def validate value
            @regex.match(value).nil? == false
          end
        end
      end
    end
  end
end
