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
require "rack-rewrite"

# Rack config {{{1
# Map static files {{{2
use Rack::Static, 
    :urls => ["/crossdomain.xml", "/humans.txt", "/robots.txt"],
    :root => "public"

# Logging and debug messages {{{2
use Rack::CommonLogger
if ENV["RACK_ENV"] == "development"
    use Rack::ShowExceptions
end

# Coderay config {{{2
use Rack::Codehighlighter, :coderay, :markdown => true, :element => "pre>code",
    :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => true

# Rewrites {{{2
use Rack::Rewrite do

    # No-www in production {{{3
    ENV['SITE_URL'] ||= 'tlvince.com'
    r301 %r{.*}, "http://#{ENV['SITE_URL']}$&", :if => Proc.new {|rack_env|
        ENV['RACK_ENV'] == 'production' && 
            rack_env['SERVER_NAME'] != ENV['SITE_URL']
    }
end

# Create, configure and start a toto instance {{{1
toto = Toto::Server.new do
    set :author, "Tom Vincent"
    set :title, "tlvince"
    set :desc, "Essays on hacking, travel and self-improvement"

    # Human-readble date format, e.g.: 8th April 2011
    set :date, lambda {|now| now.strftime("#{now.day}<sup>#{now.day.ordinal}</sup> %B, %Y") }
end

run toto
