#!/usr/bin/ruby
#
# Testing out the warnings-enabled format string bug.
# 
# Time-stamp: <08-Nov-2005 18:56:30 ged>
#

BEGIN {
	base = File::dirname( File::dirname(File::expand_path(__FILE__)) )
	$LOAD_PATH.unshift "#{base}/lib"

	require "#{base}/utils.rb"
	include UtilityFunctions
}

require 'bluecloth'

try( "warning_bug" ) {
	puts BlueCloth.new("*woo*").to_html
}


