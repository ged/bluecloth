#!/usr/bin/env ruby

require 'bluecloth'
require 'spec/matchers'

### Fixturing functions
module BlueClothMatchers

	class TransformMatcher
		
		### Create a new matcher for the given +html+
		def initialize( html )
			@html = html
		end

		### Returns true if the HTML generated by the given +bluecloth+ object matches the 
		### expected HTML, comparing only the salient document structures.
		def matches?( bluecloth )
			@bluecloth = bluecloth
			@output_html = bluecloth.to_html
			return @output_html == @html
		end
		
		### Build a failure message for the matching case.
		def failure_message
			return "Expected the generated html:\n\n  %p\n\nto be the same as:\n\n  %p\n\n" %
				[ @output_html, @html ]
		end
		
		### Build a failure message for the non-matching case.
		def negative_failure_message
			return "Expected the generated html:\n\n  %p\n\nnot to be the same as:\n\n  %p\n\n" %
				[ @output_html, @html ]
		end
	end


	class TransformRegexpMatcher
		
		### Create a new matcher for the given +regexp+
		def initialize( regexp )
			@regexp = regexp
		end
		
		### Returns true if the regexp associated with this matcher matches the output generated
		### by the specified +bluecloth+ object.
		def matches?( bluecloth )
			@bluecloth = bluecloth
			@output_html = bluecloth.to_html
			return @output_html =~ @regexp
		end
		
		### Build a failure message for the matching case.
		def failure_message
			return "Expected the generated html:\n\n   %pto match the regexp:\n\n%p\n\n" %
				[ @output_html, @regexp ]
		end
		
		
		### Build a failure message for the negative matching case.
		def negative_failure_message
			return "Expected the generated html:\n\n   %pnot to match the regexp:\n\n%p\n\n" %
				[ @output_html, @regexp ]
		end
	end
	

	### Strip indentation from the given Markdown +source+ and convert to HTML via 
	### Bluecloth and return it.
	def the_markdown( string, *options )
		if indent = string[/\A\s+/]
			indent.gsub!( /\A\n/m, '' )
			$stderr.puts "Source indent is: %p" % [ indent ] if $DEBUG
			string.gsub!( /^#{indent}/m, '' )
		end
		
		return BlueCloth.new( string, *options )
	end

	
	### Generate a matcher that expects to equal the given +html+.
	def be_transformed_into( html )
		if indent = html[/\A\s+/]
			indent.gsub!( /\A\n/m, '' )
			$stderr.puts "Output indent is: %p" % [ indent ] if $DEBUG
			html.gsub!( /^#{indent}|\A\n|\n\t*\Z/m, '' )
		end
		
		return BlueClothMatchers::TransformMatcher.new( html )
	end
	
	### Generate a matcher that expects to match the given +regexp+.
	def be_transformed_into_html_matching( regexp )
		return BlueClothMatchers::TransformMatcher.new( regexp )
	end
	
end

