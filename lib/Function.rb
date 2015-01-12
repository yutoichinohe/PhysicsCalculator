require_relative './Quantity.rb'
require_relative './Error.rb'

module Function

  @@fns = {}
  def self.function_description
    @@fns
  end

  ################ macro ################
  def self.function_from_Math(*sym, mathfn: "", description: "")
    names = []
    sym.each do |s|
      define_singleton_method s do |a|
        if a.kind_of?(Quantity) and a.dimensionless?
          Math.method(mathfn).call(a.num * a.unit.const)
        elsif a.kind_of?(Quantity)
          variable_must_be_dimensionless(s.to_s)
        else
          Math.method(mathfn).call(a)
        end
      end
      names.push(s)
    end
    str = description
    @@fns[names] = str
  end

  ################ definitions ################
  function_from_Math(:sin, mathfn: :sin, description: "sin")
  function_from_Math(:cos, mathfn: :cos, description: "cos")
  function_from_Math(:tan, mathfn: :tan, description: "tan")
  function_from_Math(:asin, mathfn: :asin, description: "arcsin")
  function_from_Math(:acos, mathfn: :acos, description: "arccos")
  function_from_Math(:atan, mathfn: :atan, description: "arctan")
  function_from_Math(:sinh, mathfn: :sinh, description: "hyperbolic sin")
  function_from_Math(:cosh, mathfn: :cosh, description: "hyperbolic cos")
  function_from_Math(:tanh, mathfn: :tanh, description: "hyperbolic tan")
  function_from_Math(:asinh, mathfn: :asinh, description: "inverse hyperbolic sin")
  function_from_Math(:acosh, mathfn: :acosh, description: "inverse hyperbolic cos")
  function_from_Math(:atanh, mathfn: :atanh, description: "inverse hyperbolic tan")
  function_from_Math(:exp, mathfn: :exp, description: "exponential")
  function_from_Math(:ln, mathfn: :log, description: "natural logarithm")
  function_from_Math(:log, :log10, mathfn: :log10, description: "10 base logarithm")

  def self.sqrt(a)
    a**(Rational(1,2))
  end
  @@fns[[:sqrt]] = "square root"

  ################ utility ################
  def self.variable_must_be_dimensionless(funcname)
    raise(DimensionError, "\"#{funcname}\" - variable must be dimensionless")
  end

  def self.method_if(arg)
    if self.methods.include?(arg.intern)
      self.method(arg)
    else
      raise(FunctionNameError, "\"#{arg}\" - function not defined")
    end
  end

end
