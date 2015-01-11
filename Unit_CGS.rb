require './Unit.rb'

CGS_standards = [:length,:mass,:time,:temperature]
CGS_standards_name = {:length => :cm,
                      :mass => :g,
                      :time => :s,
                      :temperature => :K}

class Unit_CGS < Unit
  def initialize(*hoge,
                 const: 1.0,
                 length: Rational(0),
                 mass: Rational(0),
                 time: Rational(0),
                 temperature: Rational(0),
                 dimension: nil
                )
    @@standards = CGS_standards
    @@standards_name = CGS_standards_name

    @const = const
    if dimension
      @dimension = dimension
    else
      @dimension = {
        :length => length, :mass => mass, :time => time,
        :temperature => temperature
      }
    end
  end
end
