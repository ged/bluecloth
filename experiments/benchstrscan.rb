#!/usr/bin/ruby
#
# See if it's with the extra hassle to reuse StringScanner objects instead of
# creating a new one every time.
# 
# Time-stamp: <29-Mar-2004 08:10:25 ged>
#

BEGIN {
	base = File::dirname( File::dirname(File::expand_path(__FILE__)) )
	$LOAD_PATH.unshift "#{base}/lib"

	require "#{base}/utils.rb"
	include UtilityFunctions
}

require 'benchmark'
require 'strscan'

str = "some strange otaku kidnapped my iBook"
iterations = 100_000

puts "Benchmarking StringScanner object creation strategies:\n" +
	"    (#{iterations} iterations)"
Benchmark.bm(20) do |x|
	x.report("new one every time:")   {
		iterations.times do
			s = StringScanner::new( str )
			s.scan_until( /B/ )
		end
	}

	x.report("reused:")   {
		s = StringScanner::new( str )
		iterations.times do
			s.string = str
			s.scan_until( /B/ )
		end
	}
end

