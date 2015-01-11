#!/usr/bin/env ruby

require './Function.rb'
require './Parser.rb'
require './Transform.rb'
require './Quantity_MKSA.rb'
require './Calculator.rb'

if $0 == __FILE__

  # parse("-3.14E-2 + 1[km]")
  # parse("c_0 ")
  # parse("-3.14e-2 [kpc-1 / km / sec 2 ]")
  # parse("-3.14e-2[km2]")

  # parse("180[km]/20[sec]")
  # parse("250[kpc]/1000[km/s]")
  # parse("G*5.972e24[kg]/6371[km]**2")
  # parse("180[kpc-1/km/sec-1/2]")

  # parse("(1-2)**3")
  # parse("1-2**3")

  # parse("1+2+3+4")
  # parse("1*2*3*4")

  # parse("100[m]**3*20[m]**4")
  # parse("10[m]**3**4")

  # parse("250[kpc]/1000[km/s]/1[Myr]")
  # parse("G*5.972e24[kg]/6371[km]**2")
  # parse("180[kpc-1/km/sec-1/2]")
  # parse("1[m]+1[m]")
  # parse("4[Pa]*(3[m]+2.5[m])^2-11[N]")

  # parse("q^2/4/pi/epsilon0/hbar/c")
  # parse("q^2/hbar/c in km -1 ")
  # parse("q^2/hbar/c =? [km-1/sec]")

  # parse("1[km 1 sec 2]")
  # a = parse("25[ms]")
  # b = parse("250[cm]")
  # p a<b
  # p Function.sin(parse("10"))
  # p Function.sin(10)
  # p Function.tan(parse("250[km]"))
  # p Function.methods
  # p CO.method("ho")
  # parse("h*2")
  # parse("1[h]")
  # parse("1[hh]")

  # calc = Calculator.new
  # p calc.parse_query("q^2/4/pi/epsilon0/hbar/c")
  # p calc.parse_query("180[km]/20[sec]")
  # p calc.parse_query("250[kpc]/1000[km/s] =? Myr")
  # p calc.parse_query("G*5.972e24[kg]/6371[km]**2")

  def parse(str)
    psr = Parser_Query.new
    puts "################################################################"
    p str
    p parsed = psr.parse(str)
    p transformed = Transform.new.apply(parsed)
    #    p transformed.to_s
    transformed
  rescue Parslet::ParseFailed => failure
    puts failure.cause.ascii_tree
    puts
  end
  parse("-2.59e2[hour]*(c0*2) / -0.02[au]")
  parse("tan(-2.59e2[hour]*(c0*2) / -0.02[au])")
  parse("1+sin(sin(2)**3)")
  parse("1+soin(1+sin((2[km]+3[km]))**sin(3))")

end
