require 'parslet'

class ParserUtil < Parslet::Parser
  rule(:sp) { str(' ').repeat(1) }
  rule(:sp?) { str(' ').repeat(0) }
  rule(:lp) { str('(') >> sp? }
  rule(:rp) { str(')') >> sp? }
  rule(:lb) { str('[') >> sp? }
  rule(:rb) { str(']') >> sp? }
end

class Parser < ParserUtil

  ################ number ################
  rule(:int) { (str('+') | str('-')).maybe >> match("[0-9]").repeat(1) }
  rule(:float) {
    (str('+') | str('-')).maybe >> match("[0-9]").repeat(1) >>
      str('.') >> match("[0-9]").repeat(1)
  }
  rule(:rational) {
    (str('+') | str('-')).maybe >> match("[0-9]").repeat(1) >>
      str('/') >> match("[0-9]").repeat(1)
  }


  rule(:sci) {
    (str('+') | str('-')).maybe >> match("[0-9]").repeat(1) >>
      (str('.') >> match("[0-9]").repeat(1)).maybe >>
      (match('[eE]') >> int).maybe
  }
  rule(:num) { sci >> sp? }

  ################ unit ################
  rule(:alphabets) { match("[a-zA-Z]").repeat(1) >> sp? }
  rule(:unit_term_operator) { ((str('**') | str('^')) >> sp?).maybe }
  rule(:unit_power) { (float | rational | int) >> sp? }

  rule(:unit_term) {
    alphabets.as(:unit_atom) >> (unit_term_operator >> unit_power.as(:unit_pow)).maybe
  }
  rule(:unit_operator) { ((str('*') | str('/')) >> sp?).maybe }


  rule(:unit) {
    lb >> unit_term.as(:unit_term) >>
      (unit_operator.as(:unit_op) >> unit_term.as(:unit_term)).repeat(0) >> rb
  }

  rule(:unit_nobracket) {
    unit_term.as(:unit_term) >>
      (unit_operator.as(:unit_op) >> unit_term.as(:unit_term)).repeat(0)
  }

  ################ quantity ################
  rule(:chars) { match("[0-9a-zA-Z_]").repeat(1) >> sp? }

  rule(:quantity) { (num.as(:num) >> unit.maybe.as(:unit)) | chars.as(:const) }

  ################ function ################
  rule(:funcname) { match("[0-9a-zA-Z_]").repeat(1) }
  rule(:function) {
    funcname.as(:funcname) >> lp >> expression.as(:exp) >> rp
  }

  ################ main ################
  rule(:expression_operator) { (str('+') | str('-')) >> sp? }
  rule(:expression) {
    (expression_operator.maybe.as(:exp_op) >> term.as(:term) >>
     (expression_operator.as(:exp_op) >> term.as(:term)).repeat(0)).as(:exp)
  }

  rule(:power_operator) { (str('**') | str('^')) >> sp? }
  rule(:power) {
    (function.as(:func) | factor.as(:factor)) >>
      (power_operator.as(:power_op) >> (function.as(:func) |factor.as(:factor))).repeat(0)
  }

  rule(:term_operator) { (str('*') | str('/')) >> sp? }
  rule(:term) {
    (power.as(:power) | factor.as(:factor)) >>
      (term_operator.as(:term_op) >> (power.as(:power) | factor.as(:factor))).repeat(0)
  }

  rule(:factor) { quantity.as(:quantity) |
                  (lp >> expression.as(:exp) >> rp)
  }

  ################ root ################
  root(:expression)
end

class Parser_ROOT < Parser
  ################ query ################
  rule(:query_operator) { str('=?') >> sp? }

  rule(:query_rhs) {
    (match("[a-zA-Z0-9]") | match("[-+*^/\s]")).repeat(0) >> sp?
  }

  rule(:query) {
    (expression.as(:explhs) >>
     query_operator.as(:query_op) >>
     ((query_rhs).as(:exprhs) | lb >> query_rhs.as(:exprhs) >> rb)) |
      expression.as(:exp)
  }

  ################ root ################
  rule(:ROOT) {
    query
  }
  root(:ROOT)
end
