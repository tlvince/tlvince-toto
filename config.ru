# Rackup file for tlvince.com
# Copyright 2011 Tom Vincent <http://www.tlvince.com/contact/>
# vim: set ft=ruby :

# Set up the dependencies
require "bundler" 
Bundler.setup

require "toto"

# Rack config
use Rack::Static, :urls => ["/css", "/favicon.ico"], :root => "public"
use Rack::CommonLogger

# Show debug messages
if ENV["RACK_ENV"] == "development"
    use Rack::ShowExceptions
end

# Create, configure and start a toto instance
toto = Toto::Server.new do
    set :author,    "Tom Vincent"   # blog author
    set :title,     "tlvince"       # site title

    # Human-readble date format, e.g.: 8th April 2011
    set :date, lambda {|now| now.strftime("#{now.day.ordinal} %B %Y") }
end

run toto
