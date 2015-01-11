Physics Calculator
================================================================

unit-conscious scientific calculator

- Version: 0.1.0
- Author: Yuto Ichinohe

Introduction
----------------------------------------------------------------

Physics Calculator is a simple command-line scientific calculator which is useful especially for the researchers/students engaged in natural science/engineering etc...

## features
#### unit-conscious calculation
    [MKSA]> 1[km]/1[sec]
    1000.0 m s-1
#### mathematical funcions
    [MKSA]> cos(pi)
    -1.0
#### use of multiple unit systems
    [MKSA]> q
    1.60217657e-19 s A // elementary charge in MKSA
    [MKSA]> :u
    unit system [MKSA, CGS]> cgs
    [CGS]> q
    4.80320452070309e-10 cm3/2 g1/2 s-1 // elementary charge in CGS

### Contact

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

<!--

### Installation Guide
-->

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
    [MKSA]> :u // different unit system
    unit system [MKSA, CGS]> cgs
    [CGS]> q^2/hbar/c
    0.007297352621069511 // fine structure constant in CGS
    [CGS]> :q
    bye

#### From Command-line
    $ ./Calculator.rb 1[eV] =? J
    1.60217657e-19 [J]
