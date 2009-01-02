#!/usr/bin/env ruby

require 'mkmf'
require 'fileutils'
require 'pathname'
require 'rbconfig'
include Config

versionfile = Pathname.new( __FILE__ ).dirname + 'VERSION'
version = versionfile.read.chomp

# Thanks to Daniel Berger for helping me out with this. :)
if CONFIG['host_os'].match( 'mswin' )
	$CFLAGS << ' -I.' << ' -W3' << ' -Zi'
else
	$CFLAGS << ' -I.' << ' -Wall'
end
$CPPFLAGS << %Q{ -DVERSION=\\"#{version}\\"}

# Add my own debugging hooks if building for me
if ENV['DEBUGGING_BUILD']
	$CFLAGS << ' -ggdb' << ' -DDEBUG' 
end

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

FileUtils.rm_rf( 'conftest.dSYM' ) # MacOS X cleanup
