#!/usr/bin/ruby -w
#
# Unit test for bugs found in BlueCloth
# $Id$
#
# Copyright (c) 2004 The FaerieMUD Consortium.
# 

if File::exists?( "lib/bluecloth.rb" )
	require 'tests/bctestcase'
else
	require 'bctestcase'
end

require 'timeout'

### This test case tests ...
class BugsTestCase < BlueCloth::TestCase
	BaseDir = File::dirname( File::dirname(File::expand_path( __FILE__ )) )

	### Test to be sure the README file can be transformed.
	def test_00_slow_block_regex
		contents = File::read( File::join(BaseDir,"README") )
		bcobj = BlueCloth::new( contents )

		assert_nothing_raised {
			timeout( 2 ) do
				bcobj.to_html
			end
		}
	end

	### :TODO: Add more documents and test their transforms.

	def test_10_regexp_engine_overflow_bug
		contents = File::read( File::join(BaseDir,"tests/data/re-overflow.txt") )
		bcobj = BlueCloth::new( contents )

		assert_nothing_raised {
			bcobj.to_html
		}
	end
	
end


__END__

