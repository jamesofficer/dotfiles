; treat ??, ??=, and ?. as conditional keywords
(binary_expression
  "??" @keyword.conditional)

(augmented_assignment_expression
  "??=" @keyword.conditional)

(optional_chain) @keyword.conditional
