require './Unit_MKSA.rb'
require './Quantity.rb'

module UN
  include UN_
  extend self

  #### length
  UN_.def_(:m,
           description: "meter") do
    Quantity.new(num: 1,
                 unit: Unit_MKSA.new(const: 1, length: 1))
  end
  UN_.def_(:cm,
           description: "centimeter") { 1e-2*self.m }
  UN_.def_(:mm,
           description: "millimeter") { 1e-3*self.m }
  UN_.def_(:um,
           description: "micrometer") { 1e-6*self.m }
  UN_.def_(:nm,
           description: "nanometer") { 1e-9*self.m }
  UN_.def_(:km,
           description: "kilometer") { 1000*self.m }

  UN_.def_(:au, :AU,
           description: "astronomical unit") { 149597871.0*self.km }
  UN_.def_(:pc,
           description: "parsec") { 3.08567758e16*self.m }
  UN_.def_(:kpc,
           description: "kiloparsec") { 1e3*self.pc }
  UN_.def_(:Mpc,
           description: "megaparsec") { 1e6*self.pc }

  UN_.def_(:lyr,
           description: "light year") { 9460730472580800.0*self.m }

  #### mass
  UN_.def_(:kg,
           description: "kilogram") do
    Quantity.new(num: 1,
                 unit: Unit_MKSA.new(const: 1, mass: 1))
  end
  UN_.def_(:g,
           description: "gram") { 1e-3*self.kg }
  UN_.def_(:t,
           description: "ton") { 1e3*self.kg }

  UN_.def_(:Msun, :M_sun,
           description: "solar mass") { 1.9891e30*self.kg }

  #### time
  UN_.def_(:s, :sec,
           description: "second") do
    Quantity.new(num: 1,
                 unit: Unit_MKSA.new(const: 1, time: 1))
  end

  UN_.def_(:ms,
           description: "millisecond") { 1e-3*self.s }
  UN_.def_(:us,
           description: "microsecond") { 1e-6*self.s }
  UN_.def_(:ns,
           description: "nanosecond") { 1e-9*self.s }

  UN_.def_(:min,
           description: "minute") { 60.0*self.sec }
  UN_.def_(:hour, :hr,
           description: "hour") { 60.0*self.min }
  UN_.def_(:day,
           description: "day") { 24.0*self.hour }

  UN_.def_(:yr, :year,
           description: "year") { 31556926.0*self.sec }
  UN_.def_(:Myr,
           description: "megayear") { 1e6*self.yr }
  UN_.def_(:Gyr,
           description: "gigayear") { 1e9*self.yr }

  UN_.def_(:Hz,
           description: "hertz") { self.s**-1 }

  #### energy
  UN_.def_(:N,
           description: "newton") do
    Quantity.new(num: 1,
                 unit: Unit_MKSA.new(const: 1, mass: 1, length: 1, time: -2))
  end

  UN_.def_(:Pa,
           description: "pascal") { self.N/self.m**2 }
  UN_.def_(:W,
           description: "watt") { self.N/self.s }
  UN_.def_(:J, :Joule, :joule,
           description: "joule") { self.N*self.m }
  UN_.def_(:erg,
           description: "erg") { 1e-7*self.J }

  UN_.def_(:eV,
           description: "electron volt") { 1.60217657e-19*self.J }
  UN_.def_(:keV,
           description: "kilo electron volt") { 1e3*self.eV }
  UN_.def_(:MeV,
           description: "mega electron volt") { 1e6*self.eV }
  UN_.def_(:GeV,
           description: "giga electron volt") { 1e9*self.eV }
  UN_.def_(:TeV,
           description: "tera electron volt") { 1e12*self.eV }
  UN_.def_(:PeV,
           description: "peta electron volt") { 1e15*self.eV }

  #### EM
  UN_.def_(:A,
           description: "ampere") do
    Quantity.new(num: 1,
                 unit: Unit_MKSA.new(const: 1, current: 1))
  end
  UN_.def_(:C,
           description: "coulomb") { self.A*self.s }
  UN_.def_(:V,
           description: "volt") { self.J/self.C }
  UN_.def_(:F,
           description: "farad") { self.C/self.V }
  UN_.def_(:H,
           description: "henry") { self.V/self.A*self.sec }
  UN_.def_(:T, :Tesla, :tesla,
           description: "tesla") { self.kg/self.A/self.sec**2 }
  UN_.def_(:gauss, :Gauss,
           description: "gauss") { 1e-4*self.T }

  #### temperature
  UN_.def_(:K,
           description: "kelvin") do
    Quantity.new(num: 1,
                 unit: Unit_MKSA.new(const: 1, temperature: 1))
  end
end

module CO
  include UN
  include CO_
  extend self

  CO_.def_(:c, :c0, :c_0,
           description: "speed of light") do
    Quantity.new(num: 299792458.0,
                 unit: UN.m/UN.s)
  end

  CO_.def_(:G,
           description: "gravitational constant") do
    Quantity.new(num: 6.67384e-11,
                 unit: (UN.m)**3/UN.kg/UN.sec**2)
  end

  CO_.def_(:h,
           description: "Planck's constant") do
    Quantity.new(num: 6.62606957e-34,
                 unit: UN.J*UN.sec)
  end
  CO_.def_(:hbar,
           description: "Planck's constant over twopi") { self.h/self.twopi }

  CO_.def_(:mu0, :mu_0,
           description: "permeability of vacuum") do
    Quantity.new(num: 4.0e-7*self.pi,
                 unit: UN.H/UN.m)
  end
  CO_.def_(:epsilon0, :epsilon_0, :ep0, :ep_0,
           description: "permittivity of vacuum") { 1.0/self.mu0/self.c**2 }

  CO_.def_(:q,
           description: "elementary charge") do
    Quantity.new(num: 1.60217657e-19,
                 unit: UN.C)
  end

  CO_.def_(:m_e,
           description: "electron mass") do
    Quantity.new(num: 9.10938291e-31,
                 unit: UN.kg)
  end
  CO_.def_(:m_p,
           description: "proton mass") do
    Quantity.new(num: 1.672621777e-27,
                 unit: UN.kg)
  end

  CO_.def_(:k_b, :k, :kb,
           description: "Boltzmann constant") do
    Quantity.new(num: 1.3806488e-23,
                 unit: UN.J/UN.K)
  end

end
