#!/usr/bin/ruby
#
# Tester to find a minimal case for the regexp engine overflow bug
# 
# Time-stamp: <22-Aug-2004 12:22:15 ged>
#

BEGIN {
	base = File::dirname( File::dirname(File::expand_path(__FILE__)) )
	$LOAD_PATH.unshift "#{base}/lib"

	require "#{base}/utils.rb"
	include UtilityFunctions
}

BlockTags = %w[ p div h[1-6] blockquote pre table dl ol ul script math ins del]
BlockTagPattern = BlockTags.join('|')

re = %r{
	^						# Start of line
	<(#{BlockTagPattern})	# Start tag: \2
	\b						# word break
	(.*\n)*?				# Any number of lines, minimal match
	</\1>					# Matching end tag
	[ ]*					# trailing spaces
	(?=\n+|\Z)				# End of line or document
  }ix

source = "<ul>\n<li><p>xx xxxxxxx xx xxxxxx.</p></li>\n<li><p>xxx xxxxxxx xxxx x" \
"x xxxxxxxxxxx xx:</p>\n\n<ul>\n<li><p>xxxxxxx xxxxxxx: xxxxx xxxx xxxx xxxxxxx " \
"xxxxxxx xxxxxxxx xxxxxx xx\nxxxxxxx xxx xxxxxxxxx, xxx x xxxxx xxxxx xxx xxxxxx" \
"xx xx xxx xxxxxx xxxx\nxxx xx xxxxxxxxx xx xxxx.</p>\n\n<p>xxxxx xxxxxxx xx xxx" \
" xxxx xx xx xxxxxxxxx, xxx xxxx xxxxxx xx xxxxxxx xxxx\nxxx xxxxxxx'x xxxxxx xx" \
"x. xx xxxxxxxx xxxxxxxxxxxxx xxxxxxxx.</p></li>\n<li><p>xxxxxxxxx xxxxxxx: xxxx" \
"x xxxx xxx xxxxx xx xxxxx xxx xxxxxxxx xxxxxxxxx\nxx xxx xxxxxxxx, xxx xxxxx xx" \
"xxx xxxx xxxx xxxxx xxxxxxxxxxxx xx xxx\nxxxxxxxxxxx xxxx xxx xx xxxxxxxxx xx x" \
"xxx.</p>\n\n<p>xxxxx xxxxxxx xxx xx xxxxxxxxx xxxxxx xxx-xxxx xxxxx (xx xx xxxx" \
"xxxxxx)\nxx, xx xxxxxxxxx xxxxxxxx xxxxxxx xx xxxxxxxx xx xxxxxx xxx xxxxxxx\nx" \
"xxxxxx xx xxx xxxxxxx, xxxxxx xxx xxxx xxx.</p>\n\n<p>xxxxx xxxxxxxxxx xxx xxxx" \
" xxxx xx xxxxxxxxx xxx xx xxxxx xxx xxxxx xxxxx\nxxx xxxx xxx xxxx xxxxxxxxx. x" \
"xxxxxxx xxxxxxxxxxxxx xxx xxxx-xxxxxxxxx,\nxxxx xx xxxxxx xxx xxxx.</p></li>\n<" \
"li><p>xxxxx xxxxxxx: xxxxx xxxx xxxxxx xxxx xxxxxxx xx xxxxxxx x xxxxxxxxxxx\nx" \
"xxxxx, xxxxxxx xx xxxxxxx xxxxxxxxxxxx. xxxxx xxxxxxx xxxx xx xxxxxxxxx\nxxxxxx" \
" xxx-xxxx xxxxx.</p>\n\n<p>xxxxxx xxxxxxxxx xxx x xxxx xxxxxxxxx, xxxx xx x-xxx" \
"x.</p></li>\n</ul></li>\n<li><p>xxxx xxx x xxxxxx xxxxxxx xxxx: xxxxx xxxxxxx x" \
"xxx xx xxxxxxxx, xxx xxxxxxx\nxxx xxx xxxxxx, xxx xxxxx, xxx xxxxxxxxx xxx xxxx" \
"xxx xxxx xxx xxxxxxx\nxxxxxxxx xxxx, xxx xxxx-xxx xxxx, xxx xxxxxxxx xx xxx xxx" \
"x, xxx xxx xxxxxxxx\nxx xxx xxxxxxxxx xxxx-xxx.</p></li>\n<li><p>xxx xxxxxxxxxx" \
"xx xxxxxxxxxxx (x.x.x. xxx xxxxxxxx xx xxxxxxx xxxxxxxx, xx\nxxxxxxxx xxxxxx, x" \
"xx.), xxx xxxxxxx xxxxxxxxxxx xx x xxxxxx xxxxxxx xxxx\nxxxx xx xxxxxxxxx: x xx" \
"xx-xxxxxx xx xxxx-xxxxx xxxxxxxx xx xxx xxxxxxxxxx.</p></li>\n<li><p>xxx xxx xx" \
"xx xxxxxxx xxx, xx xxxxx xxxxxx xx xxxx xx xxx xxxxxxx'x xxxxxx\nxxx. xxxxxxxx " \
"xxxxxxx xxxxxx xx xxxx xxx xxxxxxx xxxxxxx.</p>\n\n<p>x xxxxxx xxx xxx xxxxxxx " \
"xxxx xx xxxx xx xxxxxxxx. xxxxx xxxxxxxxxxxxx\nxxxxxx xx x xxxxxx xxxx xx xxxxx" \
"xx xxxx xxxx xxxxxx'x xxxxxx xxx xxx xxxx\nxxxxxxx xxx xxxxxxxxx xxxxxxxxxxx:</" \
"p>\n\n<ul>\n<li><p>xxxxxxxxx xx xxxxxx xxxxxxx xxxxxx xxxx xxxxxx (xx xxxxx xxx" \
"xxx xx xx\nxxxxxxxxxx).</p></li>\n<li><p>xxxxxxxxxxx xx xxxx xxxxxxx xxx.</p></" \
"li>\n<li><p>xxxx xx xxxxx xxxxxxx xx xxx xxxxxx.</p></li>\n<li><p>xxxx xxx xxxx" \
" xx xxxxxx xx xxxx-xx-xx xx:xx xxx (xx xxx) xxxxxx.</p></li>\n<li><p>xxxx xxx x" \
"xxxxxxx xx xxxxxxxxxxx xx xxxxxx.</p></li>\n</ul></li>\n<li><p>xxxxxx xx xxxxxx" \
"x xxxx xx xxxxxxxx xxxxxxx xxx xxxx xxxx xx xxxxxx\nxxxxx-xxxxxxxxxxxx xxxxxx x" \
"xxxxxxxxx xxxxxxx. xxxxxxxx xxxxxxx xxx xx\nxxxxxxxx xx xxxxxxxxxxx xx xxxx xxx" \
"x.</p></li>\n<li><p>xx x xxxxx xxxx:</p>\n\n<ul>\n<li>xxxx xxxxxxx xxxxxx xxxx " \
"x xxxxx-xxx xxx xxxxxx xxxxxxx, xxxxxxxx xxxxxxx,\nxxx xxxxxxxx xxxxx xxxxxxx x" \
"xxx xxxxxxxx xxxxxxx, xx xxx xxx. xxxxxxx,\nxxxx xxxxxx xxx xxxx xx xxx xxxxxxx" \
" xx xxx xxxxxx xx xxx xxxxxxx xxxxxx\n-- xxxxx xxx, xx xxxxx xxxxxx xxxxx xx xx" \
"xxx xxx xxxx xxxxxxxx -- xxx xxxx\nxxxxx xxx xxx xxxxxxxx xx xxxxxxxxx xxxxxx-x" \
"xxxxxxx xxxxxxxx.</li>\n</ul></li>\n</ul>\n"

#source.gsub!( /[ -]+/, '' )

puts "Source length: #{source.length}"

try( "re-overflow" ) {
	source.gsub!( re ) {|match| p match}
}


