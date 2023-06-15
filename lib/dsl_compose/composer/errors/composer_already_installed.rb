# frozen_string_literal: true

module DSLCompose
  module Composer
    module Errors

      class ComposerAlreadyInstalled < StandardError
        def message
          "The define_dsl singleton method already exists for this class."
        end
      end

    end
  end
end