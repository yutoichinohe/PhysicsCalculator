require './Error.rb'
require './Function.rb'

class Transform < Parslet::Transform
  attr_reader :unit_system

  def initialize
    super
    load './Quantity_MKSA.rb'
    @unit_system = :MKSA
  end
  def set_unit_system(str)
    if str == "MKSA" or str == "M"
      load './Quantity_MKSA.rb'
      @unit_system = :MKSA
    elsif str == "CGS" or str == "C"
      load './Quantity_CGS.rb'
      @unit_system = :CGS
    else
      raise(UnitSystemError, "\"#{str}\" - invalid unit system")
    end
  end

  rule(:unit_atom => simple(:a)) {
    as = a.to_s.strip
    UN.method_if(as).call
  }
  rule(:unit_atom => simple(:a),
       :unit_pow => simple(:p)) {
    as = a.to_s.strip
    ps = p.to_s.strip
    if ps.include?('.')
      (UN.method_if(as).call)**(p.to_f)
    elsif ps.include?('/')
      numerator, denominator = ps.split('/')
      (UN.method_if(as).call)**(Rational(numerator,denominator))
    else
      (UN.method_if(as).call)**(p.to_i)
    end
  }
  rule(:unit_term => simple(:t)) { t }
  rule(:unit_op => simple(:o),
       :unit_term => simple(:t)) {
    os = o.to_s.strip
    if os == '*'
      t
    elsif os == '/'
      1/t
    else
      t
    end
  }
  rule(:num => simple(:n),
       :unit => simple(:u)) {
    nf = n.to_f
    if u.kind_of?(Quantity)
      nf*u
    else
      nf
    end
  }
  rule(:num => simple(:n),
       :unit => sequence(:u)) {
    nf = n.to_f
    uf = u.reduce { |prod,unit| prod*unit }
    nf*uf
  }
  rule(:const => simple(:c)) {
    cs = c.to_s.strip
    CO.method_if(cs).call
  }
  rule(:quantity => simple(:a)) { a }
  rule(:funcname => simple(:f),
       :exp => simple(:e)) {
    fs = f.to_s.strip
    Function.method_if(fs).call(e)
  }
  rule(:func => simple(:f)) { f }
  rule(:factor => simple(:f)) { f }
  rule(:power => simple(:p)) { p }
  rule(:power_op => simple(:o),
       :factor => simple(:f)) { f }
  rule(:power_op => simple(:o),
       :func => simple(:f)) { f }
  rule(:power => sequence(:p)) {
    nums = []
    p.each do |x|
      if x.kind_of?(Hash)
        nums.push x[:factor]
      else
        nums.push x
      end
    end
    nums.reverse.reduce { |pow,base| base**pow }
  }

  rule(:term_op => simple(:o),
       :power => simple(:p)) {
    os = o.to_s.strip
    if os == '*'
      p
    elsif os == '/'
      1/p
    else
      p
    end
  }
  rule(:term_op => simple(:o),
       :power => sequence(:p)) {
    os = o.to_s.strip
    nums = []
    p.each do |x|
      if x.kind_of?(Hash)
        nums.push x[:factor]
      else
        nums.push x
      end
    end
    prod = nums.reverse.reduce { |pow,base| base**pow }
    if os == '*'
      prod
    elsif os == '/'
      1/prod
    else
      prod
    end
  }

  rule(:exp_op => simple(:o),
       :term => simple(:t)) {
    os = o.to_s.strip
    if os == '-'
      -t
    else
      t
    end
  }

  rule(:exp_op => simple(:o),
       :term => sequence(:t)) {
    os = o.to_s.strip
    tf = t.reduce { |prod,term| prod*term }
    if os == '-'
      -tf
    else
      tf
    end
  }

  rule(:exp => simple(:e)) { e }
  rule(:exp => sequence(:e)) {
    e.reduce { |sum,term| sum+term }
  }

end
