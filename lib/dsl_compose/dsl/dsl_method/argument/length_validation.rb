# frozen_string_literal: true

module DSLCompose
  class DSL
    class DSLMethod
      class Argument
        class LengthValidation
          def initialize maximum: nil, minimum: nil, is: nil
            @maximum = maximum
            @minimum = minimum
            @is = is
          end

          def validate value
            maximum = @maximum
            unless maximum.nil?
              return false unless value.length <= maximum
            end

            minimum = @minimum
            unless minimum.nil?
              return false unless value.length >= minimum
            end

            is = @is
            unless is.nil?
              return false unless value.length == is
            end

            true
          end
        end
      end
    end
  end
end
