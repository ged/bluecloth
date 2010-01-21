#!/usr/bin/ruby

# 
# Bluecloth is a Ruby implementation of Markdown, a text-to-HTML conversion
# tool.
# 
# == Authors
# 
# * Michael Granger <ged@FaerieMUD.org>
# 
# == Contributors
#
# * Martin Chase <stillflame@FaerieMUD.org> - Peer review, helpful suggestions
# * Florian Gross <flgr@ccan.de> - Filter options, suggestions
#
# This product includes software developed by David Loren Parsons
# <http://www.pell.portland.or.us/~orc>.
# 
# == Version
#
#  $Id$
# 
# == License
# 
# :include: LICENSE
#--
# Please see the LICENSE file included in the distribution for copyright and licensing details.
# 
class BlueCloth

	# Release Version
	VERSION = '2.0.7'

	# The defaults for all supported options.
	DEFAULT_OPTIONS = {
		:remove_links    => false,
		:remove_images   => false,
		:smartypants     => true,
		:pseudoprotocols => false,
		:pandoc_headers  => false,
		:header_labels   => false,
		:escape_html     => false,
		:strict_mode     => true,
		:auto_links      => false,
		:safe_links      => false,
	}.freeze

	# The number of characters of the original markdown source to include in the 
	# output of #inspect
	INSPECT_TEXT_LENGTH = 50


	#################################################################
	###	C L A S S   M E T H O D S
	#################################################################

	### Convert the specified +opthash+ into a flags bitmask. If it's already a
	### Fixnum (e.g., if someone passed in an ORed flags argument instead of an
	### opthash), just return it as-is.
	def self::flags_from_opthash( opthash={} )
		return opthash if opthash.is_a?( Integer )

		# Support BlueCloth1-style options
		if opthash == :filter_html || opthash == [:filter_html]
			opthash = { :escape_html => true }
		elsif opthash == :filter_styles
			opthash = {}
		elsif !opthash.is_a?( Hash )
			raise ArgumentError, "option %p not supported" % [ opthash ]
		end

		flags = 0

        if   opthash[:remove_links]    then flags |= MKD_NOLINKS;  end
        if   opthash[:remove_images]   then flags |= MKD_NOIMAGE;  end
        if ! opthash[:smartypants]     then flags |= MKD_NOPANTS;  end
        if ! opthash[:pseudoprotocols] then flags |= MKD_NO_EXT;   end
        if ! opthash[:pandoc_headers]  then flags |= MKD_NOHEADER; end
        if   opthash[:header_labels]   then flags |= MKD_TOC;      end
        if   opthash[:mdtest_1_compat] then flags |= MKD_1_COMPAT; end
        if   opthash[:escape_html]     then flags |= MKD_NOHTML;   end
        if   opthash[:strict_mode]     then flags |= MKD_STRICT;   end
        if   opthash[:tagtext_mode]    then flags |= MKD_TAGTEXT;  end
        if   opthash[:auto_links]      then flags |= MKD_AUTOLINK; end
        if   opthash[:safe_links]      then flags |= MKD_SAFELINK; end

		return flags
	end


	### Returns a Hash that reflects the settings from the specified +flags+ Integer.
	def self::opthash_from_flags( flags=0 )
		flags = flags.to_i

		opthash = {}
        if  ( flags & MKD_NOLINKS  ).nonzero? then opthash[:remove_links]    = true; end
        if  ( flags & MKD_NOIMAGE  ).nonzero? then opthash[:remove_images]   = true; end
        if !( flags & MKD_NOPANTS  ).nonzero? then opthash[:smartypants]     = true; end
        if !( flags & MKD_NO_EXT   ).nonzero? then opthash[:pseudoprotocols] = true; end
        if !( flags & MKD_NOHEADER ).nonzero? then opthash[:pandoc_headers]  = true; end
        if  ( flags & MKD_TOC      ).nonzero? then opthash[:header_labels]   = true; end
        if  ( flags & MKD_1_COMPAT ).nonzero? then opthash[:mdtest_1_compat] = true; end
        if  ( flags & MKD_NOHTML   ).nonzero? then opthash[:escape_html]     = true; end
        if  ( flags & MKD_STRICT   ).nonzero? then opthash[:strict_mode]     = true; end
        if  ( flags & MKD_TAGTEXT  ).nonzero? then opthash[:tagtext_mode]    = true; end
        if  ( flags & MKD_AUTOLINK ).nonzero? then opthash[:auto_links]      = true; end
        if  ( flags & MKD_SAFELINK ).nonzero? then opthash[:safe_links]      = true; end

		return opthash
	end


	#################################################################
	###	I N S T A N C E   M E T H O D S
	#################################################################

	### Return a human-readable representation of the object suitable for debugging.
	def inspect
		return "#<%s:0x%x text: %p; options: %p>" % [
			self.class.name,
			self.object_id / 2,
			self.text.length > INSPECT_TEXT_LENGTH ?
				self.text[ 0, INSPECT_TEXT_LENGTH - 5] + '[...]' :
				self.text,
			self.options,
		]
	end


	### Backward-compatible method: return +true+ if the object's :escape_html option was
	### set.
	def filter_html
		return self.options[:escape_html]
	end


	### Backward-compatible method: raises an appropriate error notifying the user that
	### BlueCloth2 doesn't support this option.
	def filter_html=( arg )
		raise NotImplementedError,
			"Sorry, this version of BlueCloth no longer supports toggling of HTML filtering" +
			"via #filter_html=. You now must create the BlueCloth object with the :escape_html" +
			"option set to true instead."
	end



end # class BlueCloth

# Load the correct version if it's a Windows binary gem
if RUBY_PLATFORM =~/(mswin|mingw)/i
	major_minor = RUBY_VERSION[ /^(\d+\.\d+)/ ] or
		raise "Oops, can't extract the major/minor version from #{RUBY_VERSION.dump}"
	require "#{major_minor}/bluecloth_ext"
else
	require 'bluecloth_ext'
end



# Set the top-level 'Markdown' constant if it isn't already set
::Markdown = ::BlueCloth unless defined?( ::Markdown )


