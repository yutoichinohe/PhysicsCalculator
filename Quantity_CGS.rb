require './Unit_CGS.rb'
require './Quantity.rb'

module UN
  include UN_
  extend self

  #### length
  def cm
    Quantity.new(num: 1, unit: Unit_CGS.new(const: 1, length: 1))
  end
  def m
    1e2*self.cm
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
    1e3*self.m
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

  #### mass
  def g
    Quantity.new(num: 1, unit: Unit_CGS.new(const: 1, mass: 1))
  end
  def kg
    1e3*self.g
  end
  def t
    1e3*self.kg
  end

  def Msun
    1.9891e30*self.kg
  end
  alias_method :M_sun, :Msun

  #### time
  def s
    Quantity.new(num: 1, unit: Unit_CGS.new(const: 1, time: 1))
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
  alias_method :hr, :hour
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
    1/self.s
  end

  #### energy
  def erg
    Quantity.new(num: 1, unit: Unit_CGS.new(const: 1, mass: 1, length: 2, time: -2))
  end

  def dyn
    self.g*self.cm/self.s**2
  end

  def J
    1e7*self.erg
  end
  alias_method :Joule, :J
  def N
    self.J/self.m
  end
  def Pa
    self.N/self.m**2
  end
  def W
    self.N/self.s
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

  #### EM
  def esu
    self.dyn**Rational(1,2)*self.cm
  end
  alias_method :statC, :esu

  def gauss
    self.dyn**Rational(1,2)/self.cm
  end
  alias_method :Gauss, :gauss


  #### temperature
  def K
    Quantity.new(num: 1, unit: Unit_CGS.new(const: 1, temperature: 1))
  end
end

module CO
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
    self.h/self.twopi
  end

  def epsilon0
    Quantity.new(num: 1.0)
  end
  alias_method :epsilon_0, :epsilon0
  alias_method :ep0, :epsilon0
  alias_method :ep_0, :epsilon0

  def mu0
    Quantity.new(num: 1.0)
  end
  alias_method :mu_0, :mu0

  def q
    self.c*Quantity.new(num: 1.60217657e-20,
                        unit: UN.g/UN.s/UN.gauss)
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

end
