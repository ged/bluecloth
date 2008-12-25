#!/usr/bin/env ruby

require 'mkmf'
require 'fileutils'
require 'pathname'

versionfile = Pathname.new( __FILE__ ).dirname + 'VERSION'
version = versionfile.read.chomp

$CFLAGS << ' -I.' << ' -Wall' << ' -ggdb' << ' -DDEBUG'
$CPPFLAGS << %Q{ -DVERSION=\\"#{version}\\"}

def fail( *messages )
	$stderr.puts( *messages )
	exit( 1 )
end

# Stuff from configure.sh
have_func( "srand" ) || have_func( "srandom" )
have_func( "random" ) || have_func( "rand" )

unless have_func( "strcasecmp" ) || have_func( "stricmp" )
	fail( "This extension requires either strcasecmp() or stricmp()" )
end
unless have_func( "strncasecmp" ) || have_func( "strnicmp" )
	fail( "This extensions requires either strncasecmp() or strnicmp()" )
end

have_header( 'mkdio.h' ) or fail( "missing mkdio.h" )

create_makefile( 'bluecloth_ext' )
