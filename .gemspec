#!/usr/bin/ruby
#
# BlueCloth RubyGems specification
# $Id$
#

require 'rubygems'
require './utils.rb'
include UtilityFunctions

spec = Gem::Specification.new do |s|
	s.name = 'BlueCloth'
	s.version = "0.0.1"
	s.platform = Gem::Platform::RUBY
	s.summary = "BlueCloth is a Ruby implementation of Markdown, a text-to-HTML conversion tool for web writers. Markdown allows you to write using an easy-to-read, easy-to-write plain text format, then convert it to structurally valid XHTML (or HTML)."
	s.requirements.push( 'strscan', 'logger' )
	s.files = getVettedManifest()
	s.require_path = 'lib'
	s.autorequire = 'bluecloth'
	s.author = "Michael Granger"
	s.email = "ged@FaerieMUD.org"
	s.rubyforge_project = "bluecloth"
	s.homepage = "http://bluecloth.rubyforge.org/"
end

if $0==__FILE__
	p spec
	Gem::Builder.new(spec).build
end
