require_relative './Unit.rb'
require_relative './Quantity.rb'

module MKSA
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
    def_(:m,
         description: "meter") do
      Quantity.new(num: 1,
                   unit: Unit_MKSA.new(const: 1, length: 1))
    end
    def_(:cm,
         description: "centimeter") { 1e-2*self.m }
    def_(:mm,
         description: "millimeter") { 1e-3*self.m }
    def_(:um,
         description: "micrometer") { 1e-6*self.m }
    def_(:nm,
         description: "nanometer") { 1e-9*self.m }
    def_(:km,
         description: "kilometer") { 1000*self.m }

    def_(:barn,
         description: "barn") { 1e-24*(self.cm)**2 }

    def_(:au, :AU,
         description: "astronomical unit") { 149597871.0*self.km }
    def_(:pc,
         description: "parsec") { 3.08567758e16*self.m }
    def_(:kpc,
         description: "kiloparsec") { 1e3*self.pc }
    def_(:Mpc,
         description: "megaparsec") { 1e6*self.pc }

    #### mass
    def_(:kg,
         description: "kilogram") do
      Quantity.new(num: 1,
                   unit: Unit_MKSA.new(const: 1, mass: 1))
    end
    def_(:g,
         description: "gram") { 1e-3*self.kg }
    def_(:t,
         description: "ton") { 1e3*self.kg }

    def_(:Msun, :M_sun,
         description: "solar mass") { 1.9891e30*self.kg }

    #### time
    def_(:s, :sec,
         description: "second") do
      Quantity.new(num: 1,
                   unit: Unit_MKSA.new(const: 1, time: 1))
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
         description: "hertz") { self.s**-1 }

    #### energy
    def_(:N,
         description: "newton") do
      Quantity.new(num: 1,
                   unit: Unit_MKSA.new(const: 1, mass: 1, length: 1, time: -2))
    end

    def_(:Pa,
         description: "pascal") { self.N/self.m**2 }
    def_(:J, :Joule, :joule,
         description: "joule") { self.N*self.m }
    def_(:W,
         description: "watt") { self.J/self.s }
    def_(:erg,
         description: "erg") { 1e-7*self.J }

    #### EM
    def_(:A,
         description: "ampere") do
      Quantity.new(num: 1,
                   unit: Unit_MKSA.new(const: 1, current: 1))
    end
    def_(:C,
         description: "coulomb") { self.A*self.s }
    def_(:V,
         description: "volt") { self.J/self.C }
    def_(:F,
         description: "farad") { self.C/self.V }
    def_(:H,
         description: "henry") { self.V/self.A*self.sec }
    def_(:T, :Tesla, :tesla,
         description: "tesla") { self.kg/self.A/self.sec**2 }
    def_(:gauss, :Gauss,
         description: "gauss") { 1e-4*self.T }

    #### temperature
    def_(:K,
         description: "kelvin") do
      Quantity.new(num: 1,
                   unit: Unit_MKSA.new(const: 1, temperature: 1))
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
         description: "permeability of vacuum") do
      Quantity.new(num: 4.0e-7*self.pi,
                   unit: UN.H/UN.m)
    end
    def_(:epsilon0, :epsilon_0, :ep0, :ep_0,
         description: "permittivity of vacuum") { 1.0/self.mu0/self.c**2 }

    def_(:q,
         description: "elementary charge") do
      Quantity.new(num: 1.602176565e-19,
                   unit: UN.C)
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
    def_(:m_n,
         description: "neutron mass") do
      Quantity.new(num: 1.674927351e-27,
                   unit: UN.kg)
    end

    def_(:k_b, :k, :kb,
         description: "Boltzmann constant") do
      Quantity.new(num: 1.3806488e-23,
                   unit: UN.J/UN.K)
    end

    def_(:sigma_s, :s_s,
         description: "Stefan-Boltzmann constant") do
      2.0*(self.pi)**5*(self.k)**4/15.0/(self.c)**2/(self.h)**3
    end

    def_(:r_e,
         description: "Classical electron radius") do
      (self.q)**2/4/self.pi/self.epsilon0/self.m_e/(self.c)**2
    end

    def_(:sigma_t, :s_t,
         description: "Thomson cross section") do
      8.0*(self.pi)*(self.r_e)**2/3.0
    end

  end

  module UN
    def_(:lyr,
         description: "light year") { self.year * MKSA::CO.c_0 }

    def_(:eV,
         description: "electron volt") { self.V * MKSA::CO.q }
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

  end

end
