#!/usr/bin/ruby
#
# Tester to find a minimal case for the regexp engine overflow bug
# 
# Time-stamp: <24-Aug-2004 22:13:35 ged>
#

BEGIN {
	$base = File::dirname( File::dirname(File::expand_path(__FILE__)) )
	$LOAD_PATH.unshift "#$base/lib"

	require "#$base/utils.rb"
	include UtilityFunctions
}

re = %r{
	(?:\n\n|\A)				# Preceded by a blank line or start of doc
	(						# $1 = the code block
	  (?:
		(?:[ ]{4} | \t)		# a tab or tab-width of spaces
		.*\n+				# ...followed by everything up to a newline
	  )+
	)
	(?=^[ ]{0,3}\S|\Z)		# $2 = non-space at line-start, or end of doc
  }x


source = File::read( "#$base/tests/data/re-overflow2.txt" )

puts "Source length: #{source.length}"

try( "re-overflow" ) {
	source.gsub!( re ) {|match| p match}
	puts "Success: '%s...'" % source[0, 20]
}


