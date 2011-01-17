#!/usr/bin/env ruby
#coding: utf-8

BEGIN {
	require 'pathname'
	basedir = Pathname.new( __FILE__ ).dirname.parent

	libdir = basedir + 'lib'
	extdir = basedir + 'ext'

	$LOAD_PATH.unshift( basedir ) unless $LOAD_PATH.include?( basedir )
	$LOAD_PATH.unshift( libdir ) unless $LOAD_PATH.include?( libdir )
	$LOAD_PATH.unshift( extdir ) unless $LOAD_PATH.include?( extdir )
}

require 'rubygems'
require 'rspec'
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
				should be_transformed_into( '<p><span id="bar">foo</span></p>' )
		end

		it "renders class: links as SPANs with a CLASS" do
			the_markdown( "[foo](class:bar)", :pseudoprotocols => true ).
				should be_transformed_into( '<p><span class="bar">foo</span></p>' )
		end

		it "renders raw: links as-is with no syntax expansion" do
			the_markdown( "[foo](raw:bar)", :pseudoprotocols => true ).
				should be_transformed_into( '<p>bar</p>' )
		end

		it "renders lang: links as language-specified blocks" do
			the_markdown( "[gift](lang:de)", :pseudoprotocols => true ).
				should be_transformed_into( '<p><span lang="de">gift</span></p>' )
		end

	end


	describe "Markdown-Extra tables" do

		it "doesn't try to render tables if :tables isn't set" do
			the_indented_markdown( <<-"END_MARKDOWN" ).should be_transformed_into(<<-"END_HTML").without_indentation
			 a   |    b
			-----|-----
			hello|sailor
			END_MARKDOWN
			<p> a   |    b
			-----|-----
			hello|sailor</p>
			END_HTML
		end

		it "renders the example from orc's blog" do
			the_indented_markdown( <<-"END_MARKDOWN", :tables => true ).should be_transformed_into(<<-"END_HTML").without_indentation
			 a   |    b
			-----|-----
			hello|sailor
			END_MARKDOWN
			<table>
			<thead>
			<tr>
			<th> a   </th>
			<th>    b</th>
			</tr>
			</thead>
			<tbody>
			<tr>
			<td>hello</td>
			<td>sailor</td>
			</tr>
			</tbody>
			</table>
			END_HTML
		end

		it "renders simple markdown-extra tables" do
			the_indented_markdown( <<-"END_MARKDOWN", :tables => true ).should be_transformed_into(<<-"END_HTML").without_indentation
			First Header  | Second Header
			------------- | -------------
			Content Cell  | Content Cell
			END_MARKDOWN
			<table>
			<thead>
			<tr>
			<th>First Header  </th>
			<th> Second Header</th>
			</tr>
			</thead>
			<tbody>
			<tr>
			<td>Content Cell  </td>
			<td> Content Cell</td>
			</tr>
			</tbody>
			</table>
			END_HTML

		end

  		it "renders tables with leading and trailing pipes" do
 			pending "Discount doesn't support this kind (yet?)" do
 				the_indented_markdown( <<-"END_MARKDOWN", :tables => true ).should be_transformed_into(<<-"END_HTML").without_indentation
 				| First Header  | Second Header |
 				| ------------- | ------------- |
 				| Content Cell  | Content Cell  |
 				| Content Cell  | Content Cell  |
 				END_MARKDOWN
 				<table>
 				<thead>
 				<tr>
 				<th>First Header  </th>
 				<th> Second Header</th>
 				</tr>
 				</thead>
 				<tbody>
 				<tr>
 				<td>Content Cell  </td>
 				<td> Content Cell</td>
 				</tr>
 				<tr>
 				<td>Content Cell  </td>
 				<td> Content Cell</td>
 				</tr>
 				</tbody>
 				</table>
 				END_HTML
 			end
  		end

  		it "renders tables with aligned columns" do
 			pending "Discount doesn't support this kind (yet?)" do
 				the_indented_markdown( <<-"END_MARKDOWN", :tables => true ).should be_transformed_into(<<-"END_HTML").without_indentation
 				| Item      | Value |
 				| --------- | -----:|
 				| Computer  | $1600 |
 				| Phone     |   $12 |
 				| Pipe      |    $1 |
 				END_MARKDOWN
 				<table>
 				<thead>
 				<tr>
 				<th>Item      </th>
 				<th align="right"> Value</th>
 				</tr>
 				</thead>
 				<tbody>
 				<tr>
 				<td>Computer </td>
 				<td align="right"> $1600</td>
 				</tr>
 				<tr>
 				<td>Phone    </td>
 				<td align="right">   $12</td>
 				</tr>
 				<tr>
 				<td>Pipe     </td>
 				<td align="right">    $1</td>
 				</tr>
 				</tbody>
 				</table>
 				END_HTML
 			end
		end
	end


	describe "tilde strike-through" do

		it "doesn't render tilde-bracketed test when :strikethrough isn't set" do
			the_markdown( "~~cancelled~~" ).
				should be_transformed_into( '<p>~~cancelled~~</p>' )
		end

		it "renders double tilde-bracketed text as strikethrough" do
			the_markdown( "~~cancelled~~", :strikethrough => true ).
				should be_transformed_into( '<p><del>cancelled</del></p>' )
		end

		it "renders tilde-bracketed text for tilde-brackets of more than two tildes" do
			the_markdown( "~~~~cancelled~~~~", :strikethrough => true ).
				should be_transformed_into( '<p><del>cancelled</del></p>' )
		end

		it "includes extra tildes in tilde-bracketed text" do
			the_markdown( "~~~cancelled~~", :strikethrough => true ).
				should be_transformed_into( '<p><del>~cancelled</del></p>' )
		end

	end

end


__END__

