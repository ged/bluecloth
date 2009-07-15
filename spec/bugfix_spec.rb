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

describe BlueCloth, "bugfixes" do
	include BlueCloth::TestConstants,
		BlueCloth::Matchers

	before( :all ) do
		@basedir = Pathname.new( __FILE__ ).dirname.parent
		@datadir = @basedir + 'spec/data'
	end



	### Test to be sure the README file can be transformed.
	it "can transform the included README file" do
		readme = @basedir + 'README'
		contents = readme.read

		bcobj = BlueCloth::new( contents )

		lambda do
			timeout( 2 ) { bcobj.to_html }
		end.should_not raise_error()
	end


	it "provides a workaround for the regexp-engine overflow bug" do
		datafile = @datadir + 're-overflow.txt'
		markdown = datafile.read

		lambda { BlueCloth.new(markdown).to_html }.should_not raise_error()
	end


	it "provides a workaround for the second regexp-engine overflow bug" do
		datafile = @datadir + 're-overflow2.txt'
		markdown = datafile.read

		lambda { BlueCloth.new(markdown).to_html }.should_not raise_error()
	end


	it "correctly wraps <strong> tags around two characters enclosed in four asterisks" do
		the_markdown( "**aa**" ).should be_transformed_into( "<p><strong>aa</strong></p>" )
	end


	it "correctly wraps <strong> tags around a single character enclosed in four asterisks" do
		the_markdown( "**a**" ).should be_transformed_into( "<p><strong>a</strong></p>" )
	end


	it "correctly wraps <strong> tags around two characters enclosed in four underscores" do
		the_markdown( "__aa__" ).should be_transformed_into( "<p><strong>aa</strong></p>" )
	end


	it "correctly wraps <strong> tags around a single character enclosed in four underscores" do
		the_markdown( "__a__" ).should be_transformed_into( "<p><strong>a</strong></p>" )
	end


	it "correctly wraps <em> tags around two characters enclosed in two asterisks" do
		the_markdown( "*aa*" ).should be_transformed_into( "<p><em>aa</em></p>" )
	end


	it "correctly wraps <em> tags around a single character enclosed in two asterisks" do
		the_markdown( "*a*" ).should be_transformed_into( "<p><em>a</em></p>" )
	end


	it "correctly wraps <em> tags around two characters enclosed in four underscores" do
		the_markdown( "_aa_" ).should be_transformed_into( "<p><em>aa</em></p>" )
	end


	it "correctly wraps <em> tags around a single character enclosed in four underscores" do
		the_markdown( "_a_" ).should be_transformed_into( "<p><em>a</em></p>" )
	end


	it "doesn't raise an error when run with $VERBOSE = true" do
		oldverbose = $VERBOSE

		lambda do
			$VERBOSE = true
			BlueCloth.new( "*woo*" ).to_html
		end.should_not raise_error()

		$VERBOSE = oldverbose
	end


	it "doesn't hang when presented with a series of hyphens (rails-security DoS/#57)" do
		the_indented_markdown( <<-"END_MARKDOWN" ).should be_transformed_into(<<-"END_HTML").without_indentation
		This line of markdown below will hang you if you're running BlueCloth 1.x.
		- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
		
		END_MARKDOWN
		<p>This line of markdown below will hang you if you're running BlueCloth 1.x.</p>

		<hr />
		END_HTML
	end


end


__END__

