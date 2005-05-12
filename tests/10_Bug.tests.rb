#!/usr/bin/ruby
#
# Unit test for bugs found in BlueCloth
# $Id$
#
# Copyright (c) 2004, 2005 The FaerieMUD Consortium.
# 

if !defined?( BlueCloth ) || !defined?( BlueCloth::TestCase )
	basedir = File::dirname( __FILE__ )
	require File::join( basedir, 'bctestcase' )
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
	
	def test_15_regexp_engine_overflow_bug2
		contents = File::read( File::join(BaseDir,"tests/data/re-overflow2.txt") )
		bcobj = BlueCloth::new( contents )

		assert_nothing_raised {
			bcobj.to_html
		}
	end
	
	def test_20_two_character_bold_asterisks
		html = nil
		str = BlueCloth::new( "**aa**" )
		assert_nothing_raised do
			html = str.to_html
		end

		assert_equal "<p><strong>aa</strong></p>", html
	end

	def test_21_two_character_bold_underscores
		html = nil
		str = BlueCloth::new( "__aa__" )
		assert_nothing_raised do
			html = str.to_html
		end

		assert_equal "<p><strong>aa</strong></p>", html
	end
	
	def test_22_two_character_emphasis_asterisks
		html = nil
		str = BlueCloth::new( "*aa*" )
		assert_nothing_raised do
			html = str.to_html
		end

		assert_equal "<p><em>aa</em></p>", html
	end

	def test_23_two_character_emphasis_underscores
		html = nil
		str = BlueCloth::new( "_aa_" )
		assert_nothing_raised do
			html = str.to_html
		end

		assert_equal "<p><em>aa</em></p>", html
	end

	def test_24_ruby_with_warnings_enabled_causes_ArgumentError
		oldverbose = $VERBOSE

		assert_nothing_raised do
			$VERBOSE = true
			BlueCloth.new( "*woo*" ).to_html
		end
	ensure
		$VERBOSE = oldverbose
	end
	
	
end


__END__

