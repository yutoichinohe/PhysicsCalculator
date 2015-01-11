require './Quantity.rb'
require './Error.rb'

module Function
  include Math

  ################ macro ################
  def self.function_from_Math(*args)
    args.each do |arg|
      define_singleton_method arg do |a|
        if a.kind_of?(Quantity) and a.dimensionless?
          Math.method(arg).call(a.num * a.unit.const)
        elsif a.kind_of?(Quantity)
          variable_must_be_dimensionless(arg.to_s)
        else
          Math.method(arg).call(a)
        end
      end
    end
  end

  ################ definitions ################
  function_from_Math :sin, :cos, :tan
  function_from_Math :asin, :acos, :atan
  function_from_Math :sinh, :cosh, :tanh
  function_from_Math :asinh, :acosh, :atanh
  function_from_Math :exp
  #### strictly, arguments of log need not be dimensionless
  function_from_Math :log10, :log
  alias_method :ln, :log
  alias_method :log, :log10
  class << self
    alias :ln :log
    alias :log :log10
  end

  def self.sqrt(a)
    a**(Rational(1,2))
  end

  ################ utility ################
  def self.variable_must_be_dimensionless(funcname)
    raise(DimensionError, "\"#{funcname}\" - variable must be dimensionless")
  end

  def self.method_if(arg)
    if self.private_method_defined?(arg)
      self.method(arg)
    else
      raise(FunctionNameError, "\"#{arg}\" - function not defined")
    end
  end

end
