#!/usr/bin/env ruby

require './Parser.rb'
require './Transform.rb'

class Calculator
  def initialize
    @psr_q = Parser_Query.new
    @psr = Parser.new
    @trans = Transform.new
  end

  def show_help
    str =
      "\e[1m################ HELP ################\n" <<
      "\e[4mCOMMANDS\e[0m\n" <<
      "    \e[1m.q, .e, :q, :e, quit, exit, Ctrl-c\n" <<
      "        \e[1mexit the program\n" <<
      "    \e[1m.h, :h, help\n" <<
      "        \e[1mshow this help\n" <<
      "    \e[1m.u, :u, unit\n" <<
      "        \e[1mchange unit system\n" <<
      ""
    str
  end

  def parse_query(str)
    begin
      @transed = @trans.apply(@psr_q.parse(str))
      self.parse_transed(@transed)
      [true, (@parsed.to_s << " [" << @parsed_dim.strip << "]").gsub("[]","").strip]
    rescue DimensionError => e
      [false, e]
    rescue ConstantNameError, UnitNameError, FunctionNameError => e
      [false, e]
    rescue Parslet::ParseFailed => e
      [false, "\"#{str}\" - invalid form"]
    rescue => e
      [false, e.class]
    ensure
      nil
    end
  end

  def parse_transed(arg)
    if arg.kind_of?(Hash)
      lhs = arg[:explhs]
      rhs = arg[:exprhs]
      rhs_str = "1[" << rhs.to_s << "]"
      parsed_rhs = @trans.apply(@psr.parse(rhs_str))
      @parsed = lhs/parsed_rhs
      @parsed_dim = rhs.to_s
    else
      @parsed = arg
      @parsed_dim = ""
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


  ################ repl ################
  def repl
    require 'readline'
    Signal.trap(:INT) {
      puts
      print "bye\n"
      exit(0)
    }
    while true
      str = Readline.readline("\e[0m[#{self.unit_system}]> ", true)

      case str
      when ".q", ".e", ":q", ":e", "quit", "exit"
        print "bye\n"
        break
      when ".h",":h", "help"
        print self.show_help
      when ".u", ":u", "unit"
        us = Readline.readline("\e[1;340munit system [MKSA, CGS]> ", true)
        result = self.set_unit_system(us.upcase)
        if result[0]
          print "\e[1;32m"
          print "unit system set to #{result[1]}\n"
          print "\e[0m"
        else
          print "\e[1;31m"
          print result[1], "\n"
          print "\e[0m"
        end
      else
        result = self.parse_query(str)
        if result[0]
          print "\e[1;32m"
          print result[1], "\n"
          print "\e[0m"
        else
          print "\e[1;31m"
          print result[1], "\n"
          print "\e[0m"
        end
      end
    end
  end

end

if $0 == __FILE__
  calc = Calculator.new
  calc.repl
end
