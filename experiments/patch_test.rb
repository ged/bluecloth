# Set up the library path
$: << 'lib'

# Require the patched bluecloth file.
require 'bluecloth_patched'

require 'test/unit'

# Trivial test-case to verify that the URL-resolver path
# works as expected.
class UrlResolverTest < Test::Unit::TestCase
   
    # An URL-resolver that checks if a link can be
    # translated into a reference to a posting on the
    # Ruby-Talk mailing list.
    #
    # A reference to a ruby-talk post should look like:
    # [ruby-talk:post_nr]
    class RubyTalkResolver
        
        # The template format for a reference to a Ruby-Talk posting.
        RUBY_TALK_FMT = "http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/%s"
    
        def resolve_url(link_id)
            puts "#{self.class} :: Resolving #{link_id}"
            if match = link_id.match(/^ruby-talk:(.*)+$/i)
                [RUBY_TALK_FMT % match.captures.first, nil]
            else
                puts "#{self.class} :: Resolv failed"
                return nil # Not a RubyTalk reference. Give it up.
            end
        end
    end
   
    class GenericResolver
        def initialize(&block)
            @proc = block
        end

        def resolve_url(link_id)
            puts "#{self.class} :: Resolving #{link_id}"
            v = @proc.call(link_id)
            puts "#{self.class} :: Resolv failed (#{link_id})" unless v
            v
        end
    end

    class IllegalUrlResolver
        def resolve_url_invalid(link_id)
            # NOOP
        end
    end

    def test_invalid_resolver
        bc = BlueCloth.new('')
        begin
            bc.url_resolver = IllegalUrlResolver.new
            raise "Invalid URL resolver should throw exception"
        rescue
            # Ok.
        end
    end

    def test_rubytalk
        
        doc = %{This is a Markdown Document referencing a [ruby-talk article][ruby-talk:97134].}
        parsed = %{<p>This is a Markdown Document referencing a <a href="http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/97134">ruby-talk article</a>.</p>}
    
        bc = BlueCloth.new(doc)
        bc.url_resolver = RubyTalkResolver.new
        assert_equal(parsed, bc.to_html)
    
    end

    def test_encode
        doc = %{
        simple text with an [inline](http://www.ruby-lang.org) ref, and a [defined][1] ref. And an [undefined][zip] ref, and a [resolvable][RESOLV] ref.

            [1]: http://rubyforge.org "RubyForge"
        }

        parsed = %{
<p>simple text with an <a href="http://www.ruby-lang.org">inline</a> ref, and a <a href="http://rubyforge.org" title="RubyForge">defined</a> ref. And an [undefined][zip] ref, and a <a href="http://www.idg.se/ctrl.rbx?zip=zap&amp;ttt=asdk&amp;hello=fghj" title="Some Title with &quot;citation&quot; marks in it">resolvable</a> ref.</p>
        }.strip

        bc = BlueCloth.new(doc)
        bc.url_resolver = GenericResolver.new do |link_id|
            if link_id =~ /^RESOLV$/i
                # Return a hard-coded url.
                [%{http://www.idg.se/ctrl.rbx?zip=zap&ttt=asdk&hello=fghj},
                %{Some Title with "citation" marks in it}]
            else
                nil
            end
        end
        
        assert_equal(parsed, bc.to_html)
        
    end
    
end
