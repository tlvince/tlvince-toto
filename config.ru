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

    # Redirects
    r301 '/linux/local-music-scrobbling/', '/2010/09/28/local-music-scrobbling/'
    r301 '/linux/tiling-window-managers/', '/2009/01/24/tiling-window-managers/'
    r301 '/work/conquering-the-miserable-programmer-paradox/', '/2011/01/22/conquering-the-miserable-programmer-paradox/'
    r301 '/computing/converting-eqium-presets-to-uniquel-izer/', '/2008/02/27/converting-eqium-presets-to-uniquel-izer/'
    r301 '/linux/prowler-home-cleaner/', '/2010/07/15/prowler-home-cleaner/'
    r301 '/awesome/tiling-window-managers/', '/2009/01/24/tiling-window-managers/'
    r301 '/dwm/tiling-window-managers-reprise/', '/2009/03/13/tiling-window-managers-reprise/'
    r301 '/work/taking-off-and-landing/', '/2010/08/14/taking-off-and-landing/'
    r301 '/linux/tiling-window-managers-reprise/', '/2009/03/13/tiling-window-managers-reprise/'
    r301 '/life/a-brief-guide-to-hong-kong/', '/2010/09/12/a-brief-guide-to-hong-kong/'
    r301 '/music-tech/converting-eqium-presets-to-uniquel-izer/', '/2008/02/27/converting-eqium-presets-to-uniquel-izer/'
    r301 '/linux/switching-to-ubuntu-linux/', '/2007/09/26/switching-to-ubuntu-linux/'
    r301 '/life/taking-off-and-landing/', '/2010/08/14/taking-off-and-landing/'
    r301 '/linux/fixing-java-apps-within-twms-using-wmname/', '/2009/03/18/fixing-java-apps-within-twms-using-wmname/'
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
