require_relative './Unit.rb'

MKSA_standards = [:length,:mass,:time,:current,:temperature]
MKSA_standards_name = {:length => :m,
                       :mass => :kg,
                       :time => :s,
                       :current => :A,
                       :temperature => :K}

class Unit_MKSA < Unit
  def initialize(*hoge,
                 const: 1.0,
                 length: Rational(0),
                 mass: Rational(0),
                 time: Rational(0),
                 current: Rational(0),
                 temperature: Rational(0),
                 dimension: nil
                )
    @@standards = MKSA_standards
    @@standards_name = MKSA_standards_name

    @const = const
    if dimension
      @dimension = dimension
    else
      @dimension = {
        :length => length, :mass => mass, :time => time,
        :current => current, :temperature => temperature
      }
    end
  end
end
