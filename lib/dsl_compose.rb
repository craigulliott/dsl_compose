# frozen_string_literal: true

require "dsl_compose/version"

require "dsl_compose/dsl/dsl_method/option/errors/invalid_description"
require "dsl_compose/dsl/dsl_method/option/errors/description_already_exists"
require "dsl_compose/dsl/dsl_method/option/errors/invalid_type"
require "dsl_compose/dsl/dsl_method/option/errors/validation_invalid_option"
require "dsl_compose/dsl/dsl_method/option/errors/validation_incompatible"
require "dsl_compose/dsl/dsl_method/option/errors/validation_already_exists"
require "dsl_compose/dsl/dsl_method/option/errors/invalid_name"

require "dsl_compose/dsl/dsl_method/errors/option_ordering"
require "dsl_compose/dsl/dsl_method/errors/option_already_exists"

require "dsl_compose/dsl/dsl_method/errors/description_already_exists"
require "dsl_compose/dsl/dsl_method/errors/invalid_name"
require "dsl_compose/dsl/dsl_method/errors/invalid_description"

require "dsl_compose/dsl/dsl_method/option"

require "dsl_compose/dsl/dsl_method"

require "dsl_compose/dsl/interpreter/errors/method_does_not_exist"
require "dsl_compose/dsl/interpreter/errors/method_is_unique"

require "dsl_compose/dsl/interpreter/result"
require "dsl_compose/dsl/interpreter"

require "dsl_compose/dsl/errors/description_already_exists"
require "dsl_compose/dsl/errors/method_already_exists"
require "dsl_compose/dsl/errors/invalid_name"
require "dsl_compose/dsl/errors/invalid_description"

require "dsl_compose/dsl"

require "dsl_compose/composer/errors/composer_already_installed"

require "dsl_compose/composer"

require "dsl_compose/dsls/errors/dsl_already_exists"

require "dsl_compose/dsls"

module DSLCompose
  class Error < StandardError
  end
end
