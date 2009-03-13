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

describe BlueCloth, "document with inline HTML" do
	include BlueCloth::TestConstants,
	        BlueCloth::Matchers

	it "preserves TABLE block" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is a regular paragraph.

		<table>
		    <tr>
		        <td>Foo</td>
		    </tr>
		</table>

		This is another regular paragraph.
		---
		<p>This is a regular paragraph.</p>

		<table>
		    <tr>
		        <td>Foo</td>
		    </tr>
		</table>

		<p>This is another regular paragraph.</p>
		---
	end

	it "preserves DIV block" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is a regular paragraph.

		<div>
		   Something
		</div>
		Something else.
		---
		<p>This is a regular paragraph.</p>

		<div>
		   Something
		</div>

		<p>Something else.</p>
		---
	end


	it "preserves HRs" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is a regular paragraph.

		<hr />

		Something else.
		---
		<p>This is a regular paragraph.</p>

		<hr />

		<p>Something else.</p>
		---
	end


	it "preserves fancy HRs" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is a regular paragraph.

		<hr class="publishers-mark" id="first-hrule" />

		Something else.
		---
		<p>This is a regular paragraph.</p>

		<hr class="publishers-mark" id="first-hrule" />

		<p>Something else.</p>
		---
	end


	it "preserves IFRAMEs" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is a regular paragraph.

		<iframe src="foo.html" id="foo-frame"></iframe>

		Something else.
		---
		<p>This is a regular paragraph.</p>

		<iframe src="foo.html" id="foo-frame"></iframe>

		<p>Something else.</p>
		---
	end


	it "preserves MathML block" do
		pending "discount doesn't support this, it explicitly matches block-level HTML elements only"
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		Examples
		--------
		
		Now that we have met some of the key players, it is time to see what we can
		do. Here are some examples and comments which illustrate the use of the basic
		layout and token elements. Consider the expression x2 + 4x + 4 = 0. A basic
		MathML presentation encoding for this would be:
		
		<math>
		  <mrow>
			<msup>
			  <mi>x</mi>
			  <mn>2</mn>
			</msup>
			<mo>+</mo>
			<mn>4</mn>
			<mi>x</mi>
			<mo>+</mo>
			<mn>4</mn>
			<mo>=</mo>
			<mn>0</mn>
		  </mrow>
		</math>
		
		This encoding will display as you would expect. However, if we were interested
		in reusing this expression in unknown situations, we would likely want to spend
		a little more effort analyzing and encoding the logical expression structure.
		---
		<h2>Examples</h2>
		
		<p>Now that we have met some of the key players, it is time to see what we can
		do. Here are some examples and comments which illustrate the use of the basic
		layout and token elements. Consider the expression x2 + 4x + 4 = 0. A basic
		MathML presentation encoding for this would be:</p>
		
		<math>
		  <mrow>
		    <msup>
		      <mi>x</mi>
		      <mn>2</mn>
		    </msup>
		    <mo>+</mo>
		    <mn>4</mn>
		    <mi>x</mi>
		    <mo>+</mo>
		    <mn>4</mn>
		    <mo>=</mo>
		    <mn>0</mn>
		  </mrow>
		</math>
		
		<p>This encoding will display as you would expect. However, if we were interested
		in reusing this expression in unknown situations, we would likely want to spend
		a little more effort analyzing and encoding the logical expression structure.</p>
		---
	end


	it "preserves span-level HTML" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is some stuff with a <span class="foo">spanned bit of text</span> in
		it. And <del>this *should* be a bit of deleted text</del> which should be
		preserved, and part of it emphasized.
		---
		<p>This is some stuff with a <span class="foo">spanned bit of text</span> in
		it. And <del>this <em>should</em> be a bit of deleted text</del> which should be
		preserved, and part of it emphasized.</p>
		---
	end

	it "preserves block-level HTML case-insensitively" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is a regular paragraph.

		<TABLE>
		    <TR>
		        <TD>Foo</TD>
		    </TR>
		</TABLE>

		This is another regular paragraph.
		---
		<p>This is a regular paragraph.</p>

		<TABLE>
		    <TR>
		        <TD>Foo</TD>
		    </TR>
		</TABLE>

		<p>This is another regular paragraph.</p>
		---
	end

	it "preserves span-level HTML case-insensitively" do
		the_indented_markdown( <<-"---" ).should be_transformed_into(<<-"---").without_indentation
		This is some stuff with a <SPAN CLASS="foo">spanned bit of text</SPAN> in
		it. And <DEL>this *should* be a bit of deleted text</DEL> which should be
		preserved, and part of it emphasized.
		---
		<p>This is some stuff with a <SPAN CLASS="foo">spanned bit of text</SPAN> in
		it. And <DEL>this <em>should</em> be a bit of deleted text</DEL> which should be
		preserved, and part of it emphasized.</p>
		---
	end


end


