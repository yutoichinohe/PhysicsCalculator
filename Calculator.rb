#!/usr/bin/env ruby

require_relative './lib/Parser.rb'
require_relative './lib/Transform.rb'

class Calculator
  def initialize
    @psr_q = Parser_ROOT.new
    @psr = Parser.new
    @trans = Transform.new
  end

  def show_help
    str =
      "\e[1m################ HELP ################\n" <<
      "\e[4mCOMMANDS\e[0m\e[1m\n" <<
      "    .q, .e, :q, :e, quit, exit, Ctrl-c\n" <<
      "        exit the program\n" <<
      "    .h, :h, help\n" <<
      "        show this help\n" <<
      "    .us, :us, unitsystem\n" <<
      "        change unit system\n" <<
      "    .c, :c, const\n" <<
      "        print available constants\n" <<
      "    .u, :u, unit\n" <<
      "        print available units\n" <<
      "    .f, :f, func\n" <<
      "        print available functions\n" <<
      "\e[4mSYNTAX\e[0m\e[1m\n" <<
      "    - available operators\n" <<
      "        addition (+), subtraction (-)\n" <<
      "        multiplication (*), division (/), power (**, ^)\n" <<
      "    - the scientific notation of numbers is allowed\n" <<
      "        ex.) -2e3, -2.0e3, -2E3\n" <<
      "        => -2000.0\n" <<
      "    - use [] to describe units\n" <<
      "        ex.) 20[km**2/sec], 20[km^2 sec-1], 20[km 2 sec -1]\n" <<
      "        => 20000000.0 m2 s-1\n" <<
      "    - use =? to convert the result into a specific unit\n" <<
      "        ex.) 20[m]=?km, 20[m] =? [km]\n" <<
      "        => 0.02 [km]\n" <<
      "    - constants are inputted directly\n" <<
      "        ex.) c => 299792458.0 m s-1, q => 1.60217657e-19 s A\n" <<
      "    - units can also be used as constants\n" <<
      "        ex.) km => 1000.0 m\n" <<
      "    - functions are inputted with ()\n" <<
      "        ex.) sin(2.0), sin(1+1), sin(2[m]/1[m])\n" <<
      "        => 0.9092974268256817\n" <<
      "    - Use = to define a local variable.\n" <<
      "        ex.) a=20[m]\n" <<
      "        => a is set to 2.0 m\n"
      ""
    str
  end

  def parse_query(str)
    begin
      @transed = @trans.apply(@psr_q.parse(str))
      self.parse_transed(@transed)

      case @result
      when :val
        [true, (@parsed.to_s << " [" << @parsed_dim.strip << "]").gsub("[]","").strip]
      when :let
        [true, "%s is set to %s"%[@name,@parsed]]
      end
    rescue DimensionError => e
      [false, e]
    rescue ConstantNameError, UnitNameError, FunctionNameError => e
      [false, e]
    rescue Parslet::ParseFailed => e
      [false, "\"#{str}\" - invalid form"]
    rescue => e
      [false, "#{e.class} - #{e}"]
    ensure
      nil
    end
  end

  def parse_transed(arg)
    if arg.kind_of?(Hash)
      if arg.include?(:query_op)
        lhs = arg[:querylhs]
        rhs = arg[:queryrhs]
        rhs_str = "1[" << rhs.to_s << "]"
        parsed_rhs = @trans.apply(@psr.parse(rhs_str))
        @parsed = lhs/parsed_rhs
        @parsed_dim = rhs.to_s
        @result = :val
        @name = ""
      elsif arg.include?(:let_op)
        lhs = arg[:letlhs].to_s.strip
        rhs = arg[:letrhs]
        Kernel.const_get(self.unit_system)::CO.def_my_constant(lhs){rhs}
        @parsed = rhs
        @parsed_dim = ""
        @result = :let
        @name = lhs
      end
    else
      @parsed = arg
      @parsed_dim = ""
      @result = :val
      @name = ""
    end
  end

  def set_unit_system(str)
    begin
      @trans.set_unit_system(str)
      [true, self.unit_system]
    rescue UnitSystemError => e
      [false, e]
    end
  end
  def unit_system
    @trans.unit_system
  end

  def show_const
    str = "\e[1m\e[4mAvailable constants\e[0m\e[1m\n"
    Kernel.const_get(self.unit_system)::CO.constant_description.each do |key,val|
      str << "%30s | %s\n" % [key.join(" "),val]
    end
    str
  end
  def show_unit
    str = "\e[1m\e[4mAvailable units\e[0m\e[1m\n"
    Kernel.const_get(self.unit_system)::UN.unit_description.each do |key,val|
      str << "%16s | %s\n" % [key.join(" "),val]
    end
    str
  end
  def show_func
    str = "\e[1m\e[4mAvailable functions\e[0m\e[1m\n"
    Function.function_description.each do |key,val|
      str << "%10s | %s\n" % [key.join(" "),val]
    end
    str
  end

  ################ repl ################
  def repl
    require 'readline'

    Signal.trap(:INT) {
      puts
      print "Bye\n"
      exit(0)
    }

    while true
      print("\e[0m")
      str = Readline.readline("[#{self.unit_system}]> ", true).strip

      case str
      when ".q", ".e", ":q", ":e", "quit", "exit"

        print "Bye\n"
        break

      when ".h", ":h", "help"

        print self.show_help

      when ".us", ":us", "unitsystem"

        print("\e[1m")
        us = Readline.readline("unit system [MKSA, CGS]> ", true)
        result = self.set_unit_system(us.upcase)
        if result[0]
          print "\e[1;32m"
          print "unit system set to #{result[1]}\e[0m\n"
        else
          print "\e[1;31m"
          print result[1], "\e[0m\n"
        end

      when ".c", ":c", "const"

        print self.show_const

      when ".u", ":u", "unit"

        print self.show_unit

      when ".f", ":f", "func"

        print self.show_func

      when ".mksa", ":mksa", "mksa"

        result = self.set_unit_system("MKSA")
        if result[0]
          print "\e[1;32m"
          print "unit system set to #{result[1]}\e[0m\n"
        else
          print "\e[1;31m"
          print result[1], "\e[0m\n"
        end

      when ".cgs", ":cgs", "cgs"

        result = self.set_unit_system("CGS")
        if result[0]
          print "\e[1;32m"
          print "unit system set to #{result[1]}\e[0m\n"
        else
          print "\e[1;31m"
          print result[1], "\e[0m\n"
        end

      when ""

      else

        result = self.parse_query(str)
        if result[0]
          print "\e[1;32m"
          print result[1], "\e[0m\n"
        else
          print "\e[1;31m"
          print result[1], "\e[0m\n"
        end

      end

    end
  end

end

if $0 == __FILE__
  calc = Calculator.new
  if ARGV.size != 0
    arg = ARGV.join(" ")
    result = calc.parse_query(arg)
    if result[0]
      print "\e[1;32m"
      print result[1], "\e[0m\n"
    else
      print "\e[1;31m"
      print result[1], "\e[0m\n"
    end
  else
    calc.repl
  end
end
