#!/usr/bin/ruby
# encoding: utf-8

require 'rspec'
require 'bluecloth'

require 'spec/lib/constants'
require 'spec/lib/matchers'

module BlueCloth::SpecHelpers
	include BlueCloth::Matchers

	###############
	module_function
	###############

	### Make an easily-comparable version vector out of +ver+ and return it.
	def vvec( ver )
		return ver.split('.').collect {|char| char.to_i }.pack('N*')
	end

end # module BlueCloth::SpecHelpers


### Mock with Rspec
Rspec.configure do |c|
	c.mock_with :rspec

	c.include( BlueCloth::SpecHelpers )
	c.include( BlueCloth::Matchers )

	c.filter_run_excluding( :ruby_19_only => true ) if
		BlueCloth::SpecHelpers.vvec( RUBY_VERSION ) < BlueCloth::SpecHelpers.vvec('1.9.0')
	c.filter_run_excluding( :pedantic => true ) unless
		ENV['MAINTAINER_MODE']
end

# vim: set nosta noet ts=4 sw=4:
