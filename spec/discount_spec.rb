#!/usr/bin/env ruby

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent

	libdir = basedir + 'lib'
	extdir = basedir + 'ext'

	$LOAD_PATH.unshift( libdir ) unless $LOAD_PATH.include?( libdir )
	$LOAD_PATH.unshift( extdir ) unless $LOAD_PATH.include?( extdir )
}

require 'rubygems'
require 'spec'
require 'bluecloth'

require 'spec/lib/helpers'
require 'spec/lib/constants'
require 'spec/lib/matchers'


#####################################################################
###	C O N T E X T S
#####################################################################

describe BlueCloth, "implementation of Discount-specific features" do
	include BlueCloth::TestConstants,
		BlueCloth::Matchers

	before( :all ) do
		@basedir = Pathname.new( __FILE__ ).dirname.parent
		@datadir = @basedir + 'spec/data'
	end


	describe "pseudo-protocols" do

		it "renders abbr: links as <abbr> phrases" do
			the_indented_markdown( <<-"---", :pseudoprotocols => true ).should be_transformed_into(<<-"---").without_indentation
			The [ASPCA](abbr:American Society for the Prevention of Cruelty to Animals).
			---
			<p>The <abbr title="American Society for the Prevention of Cruelty to Animals">ASPCA</abbr>.</p>
			---
		end

		it "renders id: links as anchors with an ID" do
			the_markdown( "[foo](id:bar)", :pseudoprotocols => true ).
				should be_transformed_into( '<p><a id="bar">foo</a></p>' )
		end

		it "renders class: links as SPANs with a CLASS" do
			the_markdown( "[foo](class:bar)", :pseudoprotocols => true ).
				should be_transformed_into( '<p><span class="bar">foo</span></p>' )
		end

		it "renders raw: links as-is with no syntax expansion" do
			the_markdown( "[foo](raw:bar)", :pseudoprotocols => true ).
				should be_transformed_into( '<p>bar</p>' )
		end

	end
end


__END__

