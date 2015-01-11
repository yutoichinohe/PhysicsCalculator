require './Unit_MKSA.rb'
require './Quantity.rb'

module UN
  include UN_
  extend self

  ################ length
  def m
    Quantity.new(num: 1, unit: Unit_MKSA.new(const: 1, length: 1))
  end
  def cm
    1e-2*self.m
  end
  def mm
    1e-3*self.m
  end
  def um
    1e-6*self.m
  end
  def nm
    1e-9*self.m
  end
  def km
    1000*self.m
  end

  def au
    149597871.0*self.km
  end
  alias_method :AU, :au

  def pc
    3.08567758e16*self.m
  end
  def kpc
    1e3*self.pc
  end
  def Mpc
    1e6*self.pc
  end

  def lyr
    9460730472580800.0*self.m
  end

  ################ mass
  def kg
    Quantity.new(num: 1, unit: Unit_MKSA.new(const: 1, mass: 1))
  end
  def g
    1e-3*self.kg
  end
  def t
    1e3*self.kg
  end

  def Msun
    1.9891e30*self.kg
  end
  alias_method :M_sun, :Msun

  ################ time
  def s
    Quantity.new(num: 1, unit: Unit_MKSA.new(const: 1, time: 1))
  end
  alias_method :sec, :s

  def ms
    1e-3*self.s
  end
  def us
    1e-6*self.s
  end
  def ns
    1e-9*self.s
  end

  def min
    60.0*self.sec
  end
  def hour
    60.0*self.min
  end
  def day
    24.0*self.hour
  end
  def yr
    31556926.0*self.sec
  end
  alias_method :year, :yr
  def Myr
    1e6*self.yr
  end
  def Gyr
    1e9*self.yr
  end

  def Hz
    self.s**-1
  end

  ################ energy
  def N
    Quantity.new(num: 1, unit: Unit_MKSA.new(const: 1, mass: 1, length: 1, time: -2))
  end

  def Pa
    self.N/self.m**2
  end
  def W
    self.N/self.s
  end
  def J
    self.N*self.m
  end
  alias_method :Joule, :J
  def erg
    1e-7*self.J
  end

  def eV
    1.60217657e-19*self.J
  end
  def keV
    1e3*self.eV
  end
  def MeV
    1e6*self.eV
  end
  def GeV
    1e9*self.eV
  end
  def TeV
    1e12*self.eV
  end
  def PeV
    1e15*self.eV
  end

  ################ EM
  def A
    Quantity.new(num: 1, unit: Unit_MKSA.new(const: 1, current: 1))
  end
  def C
    self.A*self.s
  end
  def V
    self.J/self.C
  end
  def F
    self.C/self.V
  end
  def H
    self.V/self.A*self.sec
  end
  def T
    self.kg/self.A/self.sec**2
  end
  alias_method :tesla, :T
  def gauss
    1e-4*self.T
  end
  alias_method :Gauss, :gauss

  ################ temperature
  def K
    Quantity.new(num: 1, unit: Unit_MKSA.new(const: 1, temperature: 1))
  end
end

module CO
  include Math
  include UN
  include CO_
  extend self

  def c
    Quantity.new(num: 299792458.0, unit: UN.m/UN.s)
  end
  alias_method :c0, :c
  alias_method :c_0, :c

  def G
    Quantity.new(num: 6.67384e-11, unit: (UN.m)**3/UN.kg/UN.sec**2)
  end

  def h
    Quantity.new(num: 6.62606957e-34, unit: UN.J*UN.sec)
  end
  def hbar
    self.h/2/PI
  end

  def epsilon0
    Quantity.new(num: 8.854187817e-12, unit: UN.F/UN.m)
  end
  alias_method :epsilon_0, :epsilon0
  alias_method :ep0, :epsilon0
  alias_method :ep_0, :epsilon0

  def mu0
    Quantity.new(num: 4e-7*PI, unit: UN.H/UN.m)
  end
  alias_method :mu_0, :mu0

  def q
    Quantity.new(num: 1.60217657e-19, unit: UN.C)
  end

  def m_e
    Quantity.new(num: 9.10938291e-31, unit: UN.kg)
  end
  def m_p
    Quantity.new(num: 1.672621777e-27, unit: UN.kg)
  end

  def k_b
    Quantity.new(num: 1.3806488e-23, unit: UN.J/UN.K)
  end
  alias_method :k, :k_b
  alias_method :kb, :k_b

  def e
    Quantity.new(num: E)
  end
  def pi
    Quantity.new(num: PI)
  end
  alias_method :PI, :pi
  alias_method :Pi, :pi

end
