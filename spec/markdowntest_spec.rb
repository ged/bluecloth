#!/usr/bin/env ruby

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent
	
	libdir = basedir + "lib"
	
	$LOAD_PATH.unshift( libdir ) unless $LOAD_PATH.include?( libdir )
}

begin
	require 'spec/runner'

	require 'bluecloth'
	require 'spec/lib/constants'
	require 'spec/lib/helpers'
	require 'spec/lib/matchers'
rescue LoadError
	unless Object.const_defined?( :Gem )
		require 'rubygems'
		retry
	end
	raise
end



#####################################################################
###	C O N T E X T S
#####################################################################

describe BlueCloth, "-- MarkdownTest 1.0: " do
	include BlueCloth::TestConstants,
		BlueCloth::Matchers

	markdowntest_dir = Pathname.new( __FILE__ ).dirname + 'data/markdowntest'
	Pathname.glob( markdowntest_dir + '*.text' ).each do |textfile|
		resultfile = Pathname.new( textfile.to_s.sub(/\.text/, '.html') )

		it textfile.basename( '.text' ) do
			markdown = textfile.read
			expected = resultfile.read
		
			the_markdown( markdown ).should be_transformed_into( expected )
		end
	end

end

