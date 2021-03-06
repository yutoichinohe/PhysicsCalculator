require_relative './Unit.rb'
require_relative './Error.rb'

class Quantity < Numeric

  attr_reader :num, :unit

  def initialize(*hoge, num: 1.0, unit: Unit.new)
    @num = num
    @unit = unit
    if unit.kind_of?(Quantity)
      @num = num * unit.num
      @unit = unit.unit
    end
  end

  ################ mathematical operations ################
  def +(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = coe.num, coe.unit

    if suni == ouni
      num = snum*(suni.const) + onum*(ouni.const)
      unit = suni.class.new(const: 1.0, dimension: suni.dimension)
      self.class.new(num: num, unit: unit)
    else
      incompatible_dimensions("+")
    end
  end

  def -(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = other.num, other.unit

    if suni == ouni
      num = snum*(suni.const) - onum*(ouni.const)
      unit = suni.class.new(const: 1.0, dimension: suni.dimension)
      self.class.new(num: num, unit: unit)
    else
      incompatible_dimensions("-")
    end
  end

  def *(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = coe.num, coe.unit

    tuni = suni*ouni

    num = snum*onum*(tuni.const)
    unit = tuni.class.new(const: 1.0, dimension: tuni.dimension)
    self.class.new(num: num, unit: unit)
  end

  def /(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = coe.num, coe.unit

    tuni = suni/ouni

    num = snum/onum*(tuni.const)
    unit = tuni.class.new(const: 1.0, dimension: tuni.dimension)
    self.class.new(num: num, unit: unit)
  end

  def -@
    snum, suni = self.num, self.unit
    num = -snum
    unit = suni
    self.class.new(num: num, unit: unit)
  end

  def abs
    snum, suni = self.num, self.unit
    num = snum.abs
    unit = suni
    self.class.new(num: num, unit: unit)
  end

  def **(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = coe.num, coe.unit

    if ouni.dimensionless?
      num = snum**(onum*(ouni.const))
      unit = suni.power(Rational(onum)*Rational(ouni.const))
      self.class.new(num: num, unit: unit)
    else
      index_must_be_dimensionless("**")
    end
  end

  def ^(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = coe.num, coe.unit

    if ouni.dimensionless?
      num = snum**(onum*(ouni.const))
      unit = suni.power(Rational(onum)*Rational(ouni.const))
      self.class.new(num: num, unit: unit)
    else
      index_must_be_dimensionless("^")
    end
  end

  ################ compatibility ################
  def coerce(other)
    if other.kind_of?(Quantity)
      return other, self
    elsif other.kind_of?(Unit)
      return self.class.new(num: 1.0, unit: other), self
    else
      return self.class.new(num: other, unit: self.unit.class.new), self
    end
  end

  def <=>(other)
    snum, suni = self.num, self.unit
    coe = self.coerce(other)[0]
    onum, ouni = coe.num, coe.unit

    if suni == ouni
      snum*(suni.const) <=> onum*(ouni.const)
    else
      incompatible_dimensions("<=>")
    end
  end

  ################ utilities ################
  def simplify
    snum, suni = self.num, self.unit
    num = snum*(suni.const)
    unit = suni.class.new(dimension: suni.dimension)
    self.class.new(num: num, unit: unit)
  end

  def dimensionless?
    self.unit.dimensionless?
  end

  def incompatible_dimensions(op)
    raise(DimensionError, "\"#{op}\" - incompatible dimensions")
  end

  def index_must_be_dimensionless(op)
    raise(DimensionError, "\"#{op}\" - index must be dimensionless")
  end

  ################ printing ################
  def to_f
    self.num.to_f
  end

  def to_i
    self.num.to_i
  end

  def to_s
    str = ""
    str << ((self.num)*(self.unit.const)).to_s
    str << " " << self.unit.print_unit
    str.strip
  end

end

module UN_
  extend self

  def method_if(arg)
    if self.methods.include?(arg.intern)
      self.method(arg)
    else
      raise(UnitNameError, "\"#{arg}\" - unit not defined")
    end
  end

  def def__(*sym,
            description: "",
            descriptions: Hash.new,
            &block)
    names = []
    sym.each do |s|
      define_method(s, block)
      names.push(s)
    end
    str = description + " : " + block.call.to_s
    descriptions[names] = str
  end

end

module CO_
  extend self

  def method_if(arg)
    if self.methods.include?(arg.intern)
      self.method(arg)
    else
      raise(ConstantNameError, "\"#{arg}\" - constant not defined")
    end
  end

  @@cos_ = {}
  def constant_description
    @@cos_
  end

  def def__(*sym,
            description: "",
            descriptions: Hash.new,
            &block)
    names = []
    sym.each do |s|
      define_method(s, block)
      names.push(s)
    end
    str = description + " : " + block.call.to_s
    descriptions[names] = str
  end

  def__(:e,
        description: "Napier's constant",
        descriptions: @@cos_
       ) { Math::E }
  def__(:pi, :PI, :Pi,
        description: "Pi",
        descriptions: @@cos_
       ) { Math::PI }
  def__(:twopi,
        description: "2*Pi",
        descriptions: @@cos_
       ) { Math::PI*2.0 }

  def def_my_constant(sym, &block)
    if constant_description.keys.flatten.include?(sym.intern)
      raise(ConstantNameError, "\"#{sym}\" - already defined as a constant")
    else
      def__(sym.intern, &block)
    end
  end

end

