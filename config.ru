# Rackup file for tlvince.com
# Copyright 2011 Tom Vincent <http://www.tlvince.com/contact/>
# vim: set ft=ruby :

# Set up the dependencies
require "bundler" 
Bundler.setup

require "toto"
require "rack/codehighlighter"
require "coderay"
require "coderay_bash"

# Coderay config
use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code",
    :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => true

# Rack config
use Rack::Static, 
    :urls => ["/css", "/favicon.ico", "/apple-touch-icon.png", 
        "/crossdomain.xml", "/humans.txt", "/robots.txt"],
    :root => "public"
use Rack::CommonLogger

# Show debug messages
if ENV["RACK_ENV"] == "development"
    use Rack::ShowExceptions
end

# Create, configure and start a toto instance
toto = Toto::Server.new do
    set :author, "Tom Vincent"
    set :title, "tlvince"
    set :desc, "Essays on hacking, travel and self-improvement"

    # Human-readble date format, e.g.: 8th April, 2011
    set :date, lambda {|now| now.strftime("#{now.day}<sup>#{now.day.ordinal}</sup> %B, %Y") }
end

run toto
