#!/usr/bin/env ruby

# Based on Ryan Tomayako's benchmark script from:
#   http://tomayko.com/writings/ruby-markdown-libraries-real-cheap-for-you-two-for-price-of-one

# Install dependencies like so:
#   sudo gem install rdiscount maruku rpeg-markdown bluefeather kramdown tartan --no-rdoc --no-ri

require 'benchmark'
require 'pathname'

$VERBOSE = false

EXPERIMENTS = Pathname.new( __FILE__ ).dirname
BASEDIR = EXPERIMENTS.parent
$LOAD_PATH.unshift( BASEDIR )

require EXPERIMENTS + 'old-bluecloth.rb' # bluecloth.rb 1.0.0, renamed to old-bluecloth.rb/OldBlueCloth

require 'rubygems'

require 'bluecloth'
require 'rdiscount'
require 'maruku'
require 'peg_markdown'
require 'bluefeather'
require 'kramdown'
require 'redcarpet'

ITERATIONS = 100
TEST_FILE = EXPERIMENTS + 'benchmark.txt'
TEST_DATA = TEST_FILE.read
TEST_DATA.freeze

class BlueFeatherWrapper
	VERSION = BlueFeather::VERSION

	def initialize( text )
		@text = text
	end

	def to_html
		return BlueFeather.parse( @text )
	end

	def self::name
		return "BlueFeather"
	end
end

class PEGMarkdown
	VERSION = '1.4.4'
end


class Kramdown::Document
	VERSION = Kramdown::VERSION
end

IMPLEMENTATIONS = [
	OldBlueCloth,
	BlueCloth,
	RDiscount,
	Maruku,
	PEGMarkdown,
	BlueFeatherWrapper,
	Kramdown::Document,
	Redcarpet,
]

begin
	require 'tartan/markdown'
	class Tartan::Markdown::Parser
		VERSION = Gem.loaded_specs['tartan'].version.to_s
	end
	IMPLEMENTATIONS << Tartan::Markdown::Parser
rescue LoadError, ScriptError => err
	$stderr.puts "%s while loading the 'tartan' markdown gem: %s" % [ err.class.name, err.message ]
end


$stderr.puts "Markdown -> HTML, %d iterations (%s, %d bytes)" % [ ITERATIONS, TEST_FILE, TEST_DATA.length ]
Benchmark.bmbm do |bench|
	IMPLEMENTATIONS.each do |impl|
		heading = "%s (%s)" % [ impl.name, impl.const_get(:VERSION) ]
		bench.report( heading ) { ITERATIONS.times {impl.new(TEST_DATA).to_html} }
	end
end

# ruby 1.8.7 (2009-06-12 patchlevel 174) [universal-darwin10.0]
# Markdown -> HTML, 100 iterations (experiments/benchmark.txt, 8064 bytes)
# 
#                                        user     system      total        real
# OldBlueCloth (1.1.0)               8.560000   0.760000   9.320000 (  9.333176)
# BlueCloth (2.0.8)                  0.050000   0.000000   0.050000 (  0.044746)
# RDiscount (1.6.5)                  0.050000   0.000000   0.050000 (  0.043800)
# Maruku (3.1.7.3)                   5.320000   0.120000   5.440000 (  5.439757)
# PEGMarkdown (1.4.4)                0.340000   0.000000   0.340000 (  0.337712)
# BlueFeather (0.33)                10.660000   0.630000  11.290000 ( 11.305359)
# Kramdown::Document (0.10.0)        1.480000   0.020000   1.500000 (  1.502757)
# Tartan::Markdown::Parser (0.2.1)  13.110000   0.360000  13.470000 ( 13.495817)
# 
# ruby 1.9.2p0 (2010-08-18 revision 29036) [x86_64-darwin10.4.0]
# 
#                                   user     system      total        real
# OldBlueCloth (1.1.0)          6.020000   0.050000   6.070000 (  6.078804)
# BlueCloth (2.0.8)             0.090000   0.000000   0.090000 (  0.086979)
# RDiscount (1.6.5)             0.040000   0.000000   0.040000 (  0.042072)
# Maruku (3.1.7.3)              5.020000   0.070000   5.090000 (  5.088757)
# PEGMarkdown (1.4.4)           0.350000   0.000000   0.350000 (  0.354823)
# BlueFeather (0.33)            7.370000   0.060000   7.430000 (  7.424055)
# Kramdown::Document (0.10.0)   1.140000   0.000000   1.140000 (  1.138709)

