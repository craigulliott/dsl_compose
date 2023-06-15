# frozen_string_literal: true

require "dsl_compose/version"

require "dsl_compose/dsl/dsl_method/argument/interpreter"
require "dsl_compose/dsl/dsl_method/argument"

require "dsl_compose/dsl/dsl_method/interpreter"

require "dsl_compose/dsl/dsl_method"

require "dsl_compose/dsl/interpreter"

require "dsl_compose/dsl"

require "dsl_compose/interpreter/execution/method_calls/method_call"
require "dsl_compose/interpreter/execution/method_calls"

require "dsl_compose/interpreter/execution"

require "dsl_compose/interpreter"

require "dsl_compose/composer"

require "dsl_compose/dsls"

module DSLCompose
  class Error < StandardError
  end
end
