Physics Calculator
================================================================

a command-line unit-conscious scientific calculator

- Version: 0.1.0
- Author: Yuto Ichinohe

Introduction
----------------------------------------------------------------

Physics Calculator is a simple command-line scientific calculator which is useful especially for the researchers/students engaged in natural science/engineering etc...

## Features
#### Unit-conscious calculation
    [MKSA]> 1[km]/1[sec]
    1000.0 m s-1
#### Scientific constants
    [MKSA]> G
    6.67384e-11 m3 kg-1 s-2
#### Mathematical funcions
    [MKSA]> cos(pi)
    -1.0
#### Use of multiple unit systems
    [MKSA]> q
    1.60217657e-19 s A // elementary charge in MKSA
    [MKSA]> :us
    unit system [MKSA, CGS]> cgs
    [CGS]> q
    4.80320452070309e-10 cm3/2 g1/2 s-1 // elementary charge in CGS
#### Use of local variables
     [MKSA]> a=2[km]
     a is set to 2000.0 m
     [MKSA]> a*5
     10000.0 m
#### Load forms from a file
     [MKSA]> :l forms.txt // a=2[km]
     a is set to 2000.0 m
     [MKSA]> a*2
     4000.0 m

- Yuto Ichinohe
- ISAS/JAXA, University of Tokyo
- yutoichinohe(AT)gmail.com

### GitHub

https://github.com/yutoichinohe/PhysicsCalculator

Installation
----------------------------------------------------------------

### Required Software

#### (1) [Ruby](http://www.ruby-lang.org/en/)
#### (2) [Parslet](http://kschiess.github.io/parslet/)

### Installation Guide
#### (1) Install Parslet
    $ gem install parslet
#### (2) Obtain the source
    $ git clone https://github.com/yutoichinohe/PhysicsCalculator.git

Usage
----------------------------------------------------------------
### Get Started
#### Using REPL
    $ ./Calculator.rb
    [MKSA]> 180[km]/20[sec] // unit-conscious calculation
    9000.0 m s-1
    [MKSA]> 250[kpc]/1000[km/s]=?Myr // print results in a specific unit
    244.4532762791914 [Myr]
    [MKSA]> G*5.972e24[kg]/6371[km]**2 // use of physical constant
    9.819296622997971 m s-2
    [MKSA]> cos((250[min]+3[hr])/2.5e4[sec])**ln(e*1[m]/1000[mm]) // mathematical function
    0.5131032184972966
    [MKSA]> q^2/4/pi/epsilon0/hbar/c // fine structure constant in MKSA
    0.0072973526210695135
    [MKSA]> :us // different unit system
    unit system [MKSA, CGS]> cgs
    [CGS]> q^2/hbar/c
    0.007297352621069511 // fine structure constant in CGS
    [CGS]> :mksa
    [MKSA]> a = 2*G*M_sun/c**2 // set "a" as the Schwarzschild radius of the Sun
    a is set to 2954.07146641595 m
    [MKSA]> a =? km
    2.95407146641595 [km]
    [MKSA]> a / 3000[m]
    0.9846904888053166
    [MKSA]> c0=2 // you cannot overwrite previously defined constants
    "c0" - already defined as a constant
    [MKSA]> :q
    Bye

#### From command-line
    $ ./Calculator.rb 1[eV] =? J
    1.60217657e-19 [J]

#### Commands
    .q, .e, :q, :e, quit, exit, Ctrl-c -- quit
    .h, :h, help -- show help
    .l, :l, load -- load forms from a file
    .us, :us, unitsystem -- change unit system
    .c, :c, const -- print available constants
    .u, :u, unit -- print available units
    .f, :f, func -- print available functions

#### Syntax
- Available operators  
    `addition (+), subtraction (-), multiplication (*), division (/), power (**, ^)`
- The scientific notation of numbers is allowed.  
    `ex.) -2e3, -2.0e3, -2E3 => -2000.0`
- Use [] to describe units.  
    `ex.) 20[km**2/sec], 20[km^2 sec-1], 20[km 2 sec -1] => 20000000.0 m2 s-1`
- Use =? to convert the result into a specific unit.  
    `ex.) 20[m]=?km, 20[m] =? [km] => 0.02 [km]`
- Constants are inputted directly.  
    `ex.) c => 299792458.0 m s-1, q => 1.60217657e-19 s A`
- Units can also be used as constants.  
    `ex.) km => 1000.0 m`
- Functions are inputted with ().  
    `ex.) sin(2.0), sin(1+1), sin(2[m]/1[m])  => 0.9092974268256817`
- Use = to define a local variable.  
    `ex.) a=20[m] => a is set to 2.0 m`
