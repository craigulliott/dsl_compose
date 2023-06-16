D = Steep::Diagnostic

target :lib do
  signature "sig"

  # check "lib"
  check "lib/dsl_compose/dsl.rb"

  configure_code_diagnostics(D::Ruby.strict)
end

# target :test do
#   signature "sig", "sig-private"

#   check "spec"
# end
