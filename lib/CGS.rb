require_relative './Unit.rb'
require_relative './Quantity.rb'

module CGS
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

  module UN
    extend UN_
    extend self

    ################ introspection & utility
    @@uns = {}
    def unit_description
      @@uns
    end

    def def_(*sym, description: "", &block)
      def__(*sym, description: description, descriptions: @@uns, &block)
    end

    #### length
    def_(:cm,
         description: "centimeter") do
      Quantity.new(num: 1,
                   unit: Unit_CGS.new(const: 1, length: 1))
    end
    def_(:m,
         description: "meter") { 1e2*self.cm }
    def_(:mm,
         description: "millimeter") { 1e-1*self.cm }
    def_(:um,
         description: "micrometer") { 1e-4*self.cm }
    def_(:nm,
         description: "nanometer") { 1e-7*self.cm }
    def_(:km,
         description: "kilometer") { 1e5*self.cm }

    def_(:au, :AU,
         description: "astronomical unit") { 149597871.0*self.km }
    def_(:pc,
         description: "parsec") { 3.08567758e16*self.m }
    def_(:kpc,
         description: "kiloparsec") { 1e3*self.pc }
    def_(:Mpc,
         description: "megaparsec") { 1e6*self.pc }

    def_(:lyr,
         description: "light year") { 9460730472580800.0*self.m }

    #### mass
    def_(:g,
         description: "gram") do
      Quantity.new(num: 1,
                   unit: Unit_CGS.new(const: 1, mass: 1))
    end
    def_(:kg,
         description: "kilogram") { 1e3*self.g }
    def_(:t,
         description: "ton") { 1e3*self.kg }

    def_(:Msun, :M_sun,
         description: "solar mass") { 1.9891e30*self.kg }

    #### time
    def_(:s, :sec,
         description: "second") do
      Quantity.new(num: 1,
                   unit: Unit_CGS.new(const: 1, time: 1))
    end

    def_(:ms,
         description: "millisecond") { 1e-3*self.s }
    def_(:us,
         description: "microsecond") { 1e-6*self.s }
    def_(:ns,
         description: "nanosecond") { 1e-9*self.s }

    def_(:min,
         description: "minute") { 60.0*self.sec }
    def_(:hour, :hr,
         description: "hour") { 60.0*self.min }
    def_(:day,
         description: "day") { 24.0*self.hour }

    def_(:yr, :year,
         description: "year") { 31556926.0*self.sec }
    def_(:Myr,
         description: "megayear") { 1e6*self.yr }
    def_(:Gyr,
         description: "gigayear") { 1e9*self.yr }

    def_(:Hz,
         description: "hertz") { 1/self.s }

    #### energy
    def_(:erg,
         description: "erg") do
      Quantity.new(num: 1,
                   unit: Unit_CGS.new(const: 1, mass: 1, length: 2, time: -2))
    end

    def_(:dyn,
         description: "dyne") { self.g*self.cm/self.s**2 }

    def_(:J, :Joule, :joule,
         description: "joule") { 1e7*self.erg }
    def_(:N,
         description: "newton") { self.J/self.m }
    def_(:Pa,
         description: "pascal") { self.N/self.m**2 }
    def_(:W,
         description: "watt") { self.N/self.s }

    def_(:eV,
         description: "electron volt") { 1.60217657e-19*self.J }
    def_(:keV,
         description: "kilo electron volt") { 1e3*self.eV }
    def_(:MeV,
         description: "mega electron volt") { 1e6*self.eV }
    def_(:GeV,
         description: "giga electron volt") { 1e9*self.eV }
    def_(:TeV,
         description: "tera electron volt") { 1e12*self.eV }
    def_(:PeV,
         description: "peta electron volt") { 1e15*self.eV }

    #### EM
    def_(:esu, :statC,
         description: "stat coulomb") { self.dyn**Rational(1,2)*self.cm }

    def_(:gauss, :Gauss,
         description: "gauss") { self.dyn**Rational(1,2)/self.cm }


    #### temperature
    def_(:K,
         description: "kelvin") do
      Quantity.new(num: 1,
                   unit: Unit_CGS.new(const: 1, temperature: 1))
    end
  end

  module CO
    include UN
    extend CO_
    extend self

    ################ introspection & utility
    @@cos = {}
    def constant_description
      @@cos.merge(CO_.constant_description)
    end

    def def_(*sym, description: "", &block)
      def__(*sym, description: description, descriptions: @@cos, &block)
    end

    ################ definitions
    def_(:c, :c0, :c_0,
         description: "speed of light") do
      Quantity.new(num: 299792458.0,
                   unit: UN.m/UN.s)
    end

    def_(:G,
         description: "gravitational constant") do
      Quantity.new(num: 6.67384e-11,
                   unit: (UN.m)**3/UN.kg/UN.sec**2)
    end

    def_(:h,
         description: "Planck's constant") do
      Quantity.new(num: 6.62606957e-34,
                   unit: UN.J*UN.sec)
    end
    def_(:hbar,
         description: "Planck's constant over twopi") { self.h/self.twopi }

    def_(:mu0, :mu_0,
         description: "permeability of vacuum") { 1.0 }
    def_(:epsilon0, :epsilon_0, :ep0, :ep_0,
         description: "permittivity of vacuum") { 1.0 }

    def_(:q,
         description: "elementary charge") do
      self.c*Quantity.new(num: 1.60217657e-20,
                          unit: UN.g/UN.s/UN.gauss)
    end

    def_(:m_e,
         description: "electron mass") do
      Quantity.new(num: 9.10938291e-31,
                   unit: UN.kg)
    end
    def_(:m_p,
         description: "proton mass") do
      Quantity.new(num: 1.672621777e-27,
                   unit: UN.kg)
    end

    def_(:k_b, :k, :kb,
         description: "Boltzmann constant") do
      Quantity.new(num: 1.3806488e-23,
                   unit: UN.J/UN.K)
    end

  end

end
