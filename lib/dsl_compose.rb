# frozen_string_literal: true

require "dsl_compose/version"

require "dsl_compose/dsl/arguments/argument/equal_to_validation"
require "dsl_compose/dsl/arguments/argument/format_validation"
require "dsl_compose/dsl/arguments/argument/greater_than_or_equal_to_validation"
require "dsl_compose/dsl/arguments/argument/greater_than_validation"
require "dsl_compose/dsl/arguments/argument/in_validation"
require "dsl_compose/dsl/arguments/argument/length_validation"
require "dsl_compose/dsl/arguments/argument/less_than_or_equal_to_validation"
require "dsl_compose/dsl/arguments/argument/less_than_validation"
require "dsl_compose/dsl/arguments/argument/not_in_validation"

require "dsl_compose/dsl/arguments/argument/interpreter"
require "dsl_compose/dsl/arguments/argument"
require "dsl_compose/dsl/arguments"

require "dsl_compose/dsl/dsl_method/interpreter"
require "dsl_compose/dsl/dsl_method"

require "dsl_compose/dsl/interpreter"

require "dsl_compose/dsl"

require "dsl_compose/interpreter/execution/method_calls/method_call"
require "dsl_compose/interpreter/execution/method_calls"
require "dsl_compose/interpreter/execution/arguments"
require "dsl_compose/interpreter/execution"
require "dsl_compose/interpreter"

require "dsl_compose/parser/for_children_of_parser/for_dsl_parser/for_method_parser"
require "dsl_compose/parser/for_children_of_parser/for_dsl_parser"
require "dsl_compose/parser/for_children_of_parser"
require "dsl_compose/parser/block_arguments"
require "dsl_compose/parser"

require "dsl_compose/composer"

require "dsl_compose/dsls"

module DSLCompose
  class Error < StandardError
  end
end
