#!/usr/bin/env ruby
# encoding: utf-8

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent.parent
	
	libdir = basedir + 'lib'
	extdir = basedir + 'ext'
	
	$LOAD_PATH.unshift( libdir ) unless $LOAD_PATH.include?( libdir )
	$LOAD_PATH.unshift( extdir ) unless $LOAD_PATH.include?( extdir )
}

require 'spec'
require 'bluecloth'

require 'spec/lib/helpers'
require 'spec/lib/constants'
require 'spec/lib/matchers'


#####################################################################
###	C O N T E X T S
#####################################################################

describe BlueCloth, "document with entities" do
	include BlueCloth::TestConstants,
	        BlueCloth::Matchers

	it "escapes special characters" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		The left shift operator, which is written as <<, is often used & greatly admired.
		---
		<p>The left shift operator, which is written as &lt;&lt;, is often used &amp; greatly admired.</p>
		---
	end

	it "preserves named entities" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		The left shift operator, which is written as &lt;&lt;, is often used &amp; greatly admired.
		---
		<p>The left shift operator, which is written as &lt;&lt;, is often used &amp; greatly admired.</p>
		---
	end

	it "preserves decimal-encoded entities" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		The left shift operator, which is written as &#060;&#060;, is often used &#038; greatly admired.
		---
		<p>The left shift operator, which is written as &#060;&#060;, is often used &#038; greatly admired.</p>
		---
	end

	it "preserves hex-encoded entities" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		The left shift operator, which is written as &#x3c;&#x3c;, is often used &#x26; greatly admired.
		---
		<p>The left shift operator, which is written as &#x3c;&#x3c;, is often used &#x26; greatly admired.</p>
		---
	end

end


