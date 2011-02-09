#!/usr/bin/ruby
# encoding: utf-8

require 'rspec'
require 'bluecloth'

require 'spec/lib/constants'
require 'spec/lib/matchers'

module BlueCloth::SpecHelpers
	include BlueCloth::Matchers
end


### Mock with Rspec
Rspec.configure do |c|
	c.mock_with :rspec

	c.include( BlueCloth::SpecHelpers )
	c.include( BlueCloth::Matchers )
end

# vim: set nosta noet ts=4 sw=4:
