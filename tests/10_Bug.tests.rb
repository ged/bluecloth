#!/usr/bin/ruby -w
#
# Unit test for bugs found in BlueCloth
# $Id: TEMPLATE.rb.tpl,v 1.2 2003/09/11 04:59:51 deveiant Exp $
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

	### Test to be sure the README file can be transformed.
	def test_00_slow_block_regex
		basedir = File::dirname( File::dirname(File::expand_path( __FILE__ )) )
		contents = File::read( "README" )
		bcobj = BlueCloth::new( contents )

		assert_nothing_raised {
			timeout( 2 ) do
				bcobj.to_html
			end
		}
	end

	### :TODO: Add more documents and test their transforms.
	
end


__END__

