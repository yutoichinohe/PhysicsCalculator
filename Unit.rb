class Hash
  def reset_with_standards(standards)
    standards.each do |s|
      self[s] = Rational(0)
    end
    self
  end
end

class Unit
  attr_reader :const, :dimension

  @@standards = []
  @@standards_name = {}
  def initialize(*hoge, const: 1.0, dimension: Hash.new.reset_with_standards(@@standards))
    @const = const
    @dimension = dimension
  end

  def *(other)
    coe = self.coerce(other)[0]
    con = self.const * coe.const
    dim = Hash.new

    sdim = self.dimension
    odim = coe.dimension
    @@standards.each do |s|
      dim[s] = sdim[s]+odim[s]
    end
    self.class.new(const: con, dimension: dim)
  end

  def /(other)
    coe = self.coerce(other)[0]
    con = self.const / coe.const
    dim = Hash.new

    sdim = self.dimension
    odim = coe.dimension
    @@standards.each do |s|
      dim[s] = sdim[s]-odim[s]
    end
    self.class.new(const: con, dimension: dim)
  end

  def ==(other)
    coe = self.coerce(other)[0]
    sdim = self.dimension
    odim = coe.dimension
    @@standards.each do |s|
      return false if sdim[s] != odim[s]
    end
    true
  end

  def coerce(other)
    if other.kind_of?(Unit)
      return other, self
    elsif other.kind_of?(Quantity)
      return self.class.new(const: (other.num)*(other.unit.const),
                            dimension: other.unit.dimension), self
    else
      return self.class.new(const: other), self
    end
  end

  def dimensionless?
    sdim = self.dimension
    @@standards.each do |s|
      return false if (sdim[s] != 0 and sdim[s])
    end
    return true
  end

  def power(pow)
    scon = self.const
    sdim = self.dimension

    con = scon**pow
    dim = Hash.new
    @@standards.each do |s|
      dim[s] = sdim[s]*pow if sdim[s]
    end
    self.class.new(const: con, dimension: dim)
  end

  def **(other)
    self.power(other)
  end

  def print_unit
    str = ""
    sdim = self.dimension
    @@standards.each do |s|
      if sdim[s] != 0 and sdim[s]
        str << @@standards_name[s].to_s
        if sdim[s] != 1
          if sdim[s].denominator == 1
            str << sdim[s].numerator.to_s << " "
          else
            str << sdim[s].to_s << " "
          end
        else
          str << " "
        end
      end
    end
    str.strip
  end

end
