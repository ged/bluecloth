#!/usr/bin/ruby
#
# Experiment to rough html-tokenizing into shape.
# 
# Time-stamp: <27-Mar-2004 23:51:29 ged>
#

BEGIN {
	base = File::dirname( File::dirname(File::expand_path(__FILE__)) )
	$LOAD_PATH.unshift "#{base}/lib"

	require 'bluecloth'

	require "#{base}/utils.rb"
	include UtilityFunctions
}

html = <<EOF
<html>
  <head><title>FOo</title></head>
  <body bar=\"<foof <the<bazzle><> bar>>\">
    <h1>Stuff</h1>
    <p>And stuff.</p>
  </body>
</html>
EOF

try( "Tokenizing HTML" ) {
	bc = BlueCloth::new
	bc.tokenizeHTML( html )
}


