#!/usr/bin/env ruby

require_relative './lib/Parser.rb'
require_relative './lib/Transform.rb'

$colorless = false

def string_with_color(str,col)
  if $colorless
    str
  else
    s = ""
    case col
    when :white
      s << "\e[0m"
      s << str
      s << "\e[0m"
    when :bwhite
      s << "\e[1m"
      s << str
      s << "\e[0m"
    when :red
      s << "\e[1;31m"
      s << str
      s << "\e[0m"
    when :green
      s << "\e[1;32m"
      s << str
      s << "\e[0m"
    else
      s << str
    end
    s
  end
end

def print_with_color(str,col)
  print string_with_color(str.to_s, col)
  print "\n"
end

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
      "    .l, :l, load\n" <<
      "        load forms from a file\n" <<
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
      "    - use = to define a local variable\n" <<
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
      exit 0
    }

    while true
#      str = Readline.readline(string_with_color("[#{self.unit_system}]> ", :white), true)
      str = Readline.readline("[#{self.unit_system}]> ", true)
      if str
        str = str.strip
      end

      case str
      when ".q", ".e", ":q", ":e", "quit", "exit"

        print "Bye\n"
        break

      when ".h", ":h", "help"

        print self.show_help

      when ".us", ":us", "unitsystem"

        us = Readline.readline(string_with_color("unit system [MKSA, CGS]> ", :bwhite), true)
        result = self.set_unit_system(us.upcase)
        if result[0]
          print_with_color("unit system set to #{result[1]}", :green)
        else
          print_with_color(result[1], :red)
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
          print_with_color("unit system set to #{result[1]}", :green)
        else
          print_with_color(result[1], :red)
        end

      when ".cgs", ":cgs", "cgs"

        result = self.set_unit_system("CGS")
        if result[0]
          print_with_color("unit system set to #{result[1]}", :green)
        else
          print_with_color(result[1], :red)
        end

      when /(\.l|:l|load).*/
        filename = str.strip.split[1]
        until filename
          filename = Readline.readline(string_with_color("load> ", :bwhite), true).strip
        end
        if File.exist?(filename)
          File.open(filename).each do |line|
            result = self.parse_query(line.strip)
            print_with_color(result[1], result[0] ? :green : :red)
          end
        else
          print_with_color("File \"#{filename}\" not found", :red)
        end

      when ""
      else

        result = self.parse_query(str)
        print_with_color(result[1], result[0] ? :green : :red)

      end

    end
  end

end

if $0 == __FILE__
  require 'optparse'
  option={}
  OptionParser.new do |opt|
    opt.on('-l [file]',
           'start command with loading a file') {|v| option[:l] = v}
    opt.on('-x [file]',
           'start command with loading a file but only returns the last result') {|v| option[:x] = v}
    opt.on('-c',
           'start command with cgs unit system') {|v| option[:c] = v}
    opt.parse!(ARGV)
  end

  calc = Calculator.new

  if option.key? :c
    calc.set_unit_system("CGS")
  end

  if option.key? :x
    $colorless = true
    if ARGV.size == 0
      result = [nil,nil,nil]
      if f = option[:x]
        File.open(f).each do |line|
          result = calc.parse_query(line.strip)
        end
      end
      print_with_color(result[1], result[0] ? :green : :red)
    else
      if f = option[:x]
        File.open(f).each do |line|
          result = calc.parse_query(line.strip)
        end
      end
      arg = ARGV.join(" ")
      result = calc.parse_query(arg)
      print_with_color(result[1], result[0] ? :green : :red)
    end
  elsif ARGV.size != 0
    $colorless = true
    arg = ARGV.join(" ")
    result = calc.parse_query(arg)
    print_with_color(result[1], result[0] ? :green : :red)
  else
    require 'readline'
    if option.key? :l
      str = option[:l]
      filename = str ? str.strip : nil
      until filename
        filename = Readline.readline(string_with_color("load> ", :bwhite), true).strip
      end
      if File.exist?(filename)
        File.open(filename).each do |line|
          result = calc.parse_query(line.strip)
          print_with_color(result[1], result[0] ? :green : :red)
        end
      else
        print_with_color("File \"#{filename}\" not found", :red)
      end
    end
    calc.repl
  end

end
