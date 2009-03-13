#!/usr/bin/ruby

puts ">>> Adding lib and ext to load path..."
$LOAD_PATH.unshift( "lib", "ext" )

# Try to require the 'bluecloth' library
begin
	puts "Requiring Bluecloth..."
		require "bluecloth"
rescue => e
	$stderr.puts "Ack! Bluecloth library failed to load: #{e.message}\n\t" +
		e.backtrace.join( "\n\t" )
end


__END__
Local Variables:
mode: ruby

