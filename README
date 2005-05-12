
BlueCloth
=========

Version 1.0.0 - 2004/08/24

Original version by John Gruber <http://daringfireball.net/>.  
Ruby port by Michael Granger <http://www.deveiate.org/>.

BlueCloth is a Ruby implementation of [Markdown][1], a text-to-HTML conversion
tool for web writers. To quote from the project page: Markdown allows you to
write using an easy-to-read, easy-to-write plain text format, then convert it to
structurally valid XHTML (or HTML).

It borrows a naming convention and several helpings of interface from
[Redcloth][2], [Why the Lucky Stiff][3]'s processor for a similar text-to-HTML
conversion syntax called [Textile][4].


Installation
------------

You can install this module either by running the included `install.rb` script,
or by simply copying `lib/bluecloth.rb` to a directory in your load path.


Dependencies
------------

BlueCloth uses the `StringScanner` class from the `strscan` library, which comes
with Ruby 1.8.x and later or may be downloaded from the RAA for earlier
versions, and the `logger` library, which is also included in 1.8.x and later.


Example Usage
-------------

The BlueCloth class is a subclass of Ruby's String, and can be used thusly:

    bc = BlueCloth::new( str )
    puts bc.to_html

This `README` file is an example of Markdown syntax. The sample program
`bluecloth` in the `bin/` directory can be used to convert this (or any other)
file with Markdown syntax into HTML:

    $ bin/bluecloth README > README.html


Acknowledgements
----------------

This library is a port of the canonical Perl one, and so owes most of its
functionality to its author, John Gruber. The bugs in this code are most
certainly an artifact of my porting it and not an artifact of the excellent code
from which it is derived.

It also, as mentioned before, borrows its API liberally from RedCloth, both for
compatibility's sake, and because I think Why's code is beautiful. His excellent
code and peerless prose have been an inspiration to me, and this module is
intended as the sincerest flattery.

Also contributing to any success this module may enjoy are those among my peers
who have taken the time to help out, either by submitting patches, testing, or
offering suggestions and review:

* Martin Chase <stillflame@FaerieMUD.org>
* Florian Gross <flgr@ccan.de>


Author/Legal
------------

Original version:  
  Copyright (c) 2004, John Gruber  
  <http://daringfireball.net/>  
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice,
	this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
	notice, this list of conditions and the following disclaimer in the
	documentation and/or other materials provided with the distribution.

  * Neither the name "Markdown" nor the names of its contributors may
	be used to endorse or promote products derived from this software
	without specific prior written permission.

  This software is provided by the copyright holders and contributors "as
  is" and any express or implied warranties, including, but not limited
  to, the implied warranties of merchantability and fitness for a
  particular purpose are disclaimed. In no event shall the copyright owner
  or contributors be liable for any direct, indirect, incidental, special,
  exemplary, or consequential damages (including, but not limited to,
  procurement of substitute goods or services; loss of use, data, or
  profits; or business interruption) however caused and on any theory of
  liability, whether in contract, strict liability, or tort (including
  negligence or otherwise) arising in any way out of the use of this
  software, even if advised of the possibility of such damage.


Ruby version:  
  This module is Open Source Software which is Copyright (c) 2004 by The FaerieMUD
  Consortium.

  You may use, modify, and/or redistribute this software under the same terms as
  Ruby itself.

  BlueCloth is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE.  See the GNU General Public License for more details.


[1]: http://daringfireball.net/projects/markdown/
[2]: http://www.whytheluckystiff.net/ruby/redcloth/
[3]: http://www.whytheluckystiff.net/
[4]: http://www.textism.com/tools/textile/

$Id$  
$URL$
