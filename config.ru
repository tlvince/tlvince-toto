# Rackup file for tlvince.com {{{1
# Copyright 2011 Tom Vincent <http://www.tlvince.com/contact/>
# vim: set ft=ruby fdm=marker :

# Set up the dependencies {{{1
require "bundler" 
Bundler.setup

require "toto"
require "rack/codehighlighter"
require "coderay"
require "coderay_bash"

# Rack config {{{1
use Rack::Static, 
    :urls => ["/crossdomain.xml", "/humans.txt", "/robots.txt"],
    :root => "public"
use Rack::CommonLogger

# Show debug messages
if ENV["RACK_ENV"] == "development"
    use Rack::ShowExceptions
end

# Coderay config {{{2
use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code",
    :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => true

# Create, configure and start a toto instance {{{1
toto = Toto::Server.new do
    set :author, "Tom Vincent"
    set :title, "tlvince"
    set :desc, "Essays on hacking, travel and self-improvement"

    # Human-readble date format, e.g.: 8th April, 2011
    set :date, lambda {|now| now.strftime("#{now.day}<sup>#{now.day.ordinal}</sup> %B, %Y") }
end

run toto
