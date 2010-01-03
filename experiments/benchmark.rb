#!/usr/bin/env ruby

# Based on Ryan Tomayako's benchmark script from:
#   http://tomayko.com/writings/ruby-markdown-libraries-real-cheap-for-you-two-for-price-of-one

require 'benchmark'
require 'pathname'

EXPERIMENTS = Pathname.new( __FILE__ ).dirname

require EXPERIMENTS + 'old-bluecloth.rb' # bluecloth.rb 1.0.0, renamed to old-bluecloth.rb/OldBlueCloth

require 'rubygems'

require 'bluecloth'
require 'rdiscount'
require 'maruku'
require 'peg_markdown'
require 'bluefeather'
require 'tartan/markdown'
require 'kramdown'

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
	VERSION = Gem.loaded_specs['rpeg-markdown'].version.to_s
end

class Tartan::Markdown::Parser
	VERSION = Gem.loaded_specs['tartan'].version.to_s
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
	Tartan::Markdown::Parser,
	Kramdown::Document,
]

$stderr.puts "Markdown -> HTML, %d iterations (%s, %d bytes)" % [ ITERATIONS, TEST_FILE, TEST_DATA.length ]
Benchmark.bmbm do |bench|
	IMPLEMENTATIONS.each do |impl|
		heading = "%s (%s)" % [ impl.name, impl.const_get(:VERSION) ]
		bench.report( heading ) { ITERATIONS.times {impl.new(TEST_DATA).to_html} }
	end
end

# ruby 1.8.7 (2008-08-11 patchlevel 72) [i686-darwin9.6.0]
# Markdown -> HTML, 100 iterations (experiments/benchmark.txt, 8064 bytes)
# Rehearsal ------------------------------------------------
# OldBlueCloth  17.750000   1.000000  18.750000 ( 18.789201)
# BlueCloth      0.080000   0.010000   0.090000 (  0.088035)
# RDiscount      0.110000   0.000000   0.110000 (  0.104491)
# Maruku         9.100000   0.070000   9.170000 (  9.192100)
# PEGMarkdown    0.500000   0.010000   0.510000 (  0.501156)
# -------------------------------------- total: 28.630000sec
# 
#                    user     system      total        real
# OldBlueCloth  17.760000   0.980000  18.740000 ( 18.772004)
# BlueCloth      0.080000   0.000000   0.080000 (  0.082273)
# RDiscount      0.080000   0.000000   0.080000 (  0.085950)
# Maruku         8.910000   0.050000   8.960000 (  8.982518)
# PEGMarkdown    0.500000   0.010000   0.510000 (  0.513450)
# 

