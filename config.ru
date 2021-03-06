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

if ENV["RACK_ENV"] == "production"
    require "newrelic_rpm"
end

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
    :pattern => /\A:::(\w+)\s*(\n|&#x000A;)/i, :logging => false

# Rewrites {{{2
use Rack::Rewrite do

    # No-www in production {{{3
    ENV['SITE_URL'] ||= 'tlvince.com'
    r301 %r{.*}, "http://#{ENV['SITE_URL']}$&", :if => Proc.new {|rack_env|
        ENV['RACK_ENV'] == 'production' && 
            rack_env['SERVER_NAME'] != ENV['SITE_URL']
    }

    # Redirects generated by: {{{3
    # https://github.com/tlvince/gen301
    r301 '/awesome/tiling-window-managers/', '/2009/01/24/tiling-window-managers/'
    r301 '/computing/command-line-basics-and-batch-files/', '/2007/07/25/command-line-basics-and-batch-files/'
    r301 '/computing/converting-eqium-presets-to-uniquel-izer/', '/2008/02/27/converting-eqium-presets-to-uniquel-izer/'
    r301 '/computing/gmail-reply-to-all/', '/2011/04/08/gmail-reply-to-all/'
    r301 '/computing/hosts-adblock/', '/2010/08/02/hosts-adblock/'
    r301 '/computing/xbox-modding/', '/2007/07/08/xbox-modding/'
    r301 '/dwm/tiling-window-managers-reprise/', '/2009/03/13/tiling-window-managers-reprise/'
    r301 '/hong-kong/taking-off-and-landing/', '/2010/08/14/taking-off-and-landing/'
    r301 '/java/fixing-java-apps-within-twm%E2%80%99s-using-wmname/', '/2009/03/18/fixing-java-apps-within-twms-using-wmname/'
    r301 '/life/a-brief-guide-to-hong-kong/', '/2010/09/12/a-brief-guide-to-hong-kong/'
    r301 '/life/businessmen-they-drink-my-wine/', '/2010/08/16/businessmen-they-drink-my-wine/'
    r301 '/life/conquering-the-miserable-programmer-paradox/', '/2011/01/22/conquering-the-miserable-programmer-paradox/'
    r301 '/life/manila-paradise-lost/', '/2010/11/26/manila-paradise-lost/'
    r301 '/life/pass-the-salt/', '/2011/03/30/pass-the-salt/'
    r301 '/life/taking-off-and-landing/', '/2010/08/14/taking-off-and-landing/'
    r301 '/linux/915resolution-after-ubuntu-upgrade-to-gutsy/', '/2007/10/05/915resolution-after-ubuntu-upgrade-to-gutsy/'
    r301 '/linux/fixing-java-apps-within-twm%E2%80%99s-using-wmname/', '/2009/03/18/fixing-java-apps-within-twms-using-wmname/'
    r301 '/linux/fixing-java-apps-within-twms-using-wmname/', '/2009/03/18/fixing-java-apps-within-twms-using-wmname/'
    r301 '/linux/local-music-scrobbling/', '/2010/09/28/local-music-scrobbling/'
    r301 '/linux/prowler-home-cleaner/', '/2010/07/15/prowler-home-cleaner/'
    r301 '/linux/slow-zsh-completion/', '/2011/04/05/slow-zsh-completion/'
    r301 '/linux/switching-to-ubuntu-linux/', '/2007/09/26/switching-to-ubuntu-linux/'
    r301 '/linux/tiling-window-managers/', '/2009/01/24/tiling-window-managers/'
    r301 '/linux/tiling-window-managers-reprise/', '/2009/03/13/tiling-window-managers-reprise/'
    r301 '/linux/vim-respect-xdg/', '/2011/02/03/vim-respect-xdg/'
    r301 '/music-tech/converting-eqium-presets-to-uniquel-izer/', '/2008/02/27/converting-eqium-presets-to-uniquel-izer/'
    r301 '/tag/adblock/', '/2010/08/02/hosts-adblock/'
    r301 '/tag/miserable/', '/2011/01/22/conquering-the-miserable-programmer-paradox/'
    r301 '/tag/prowler/', '/2010/07/15/prowler-home-cleaner/'
    r301 '/tag/wmname/', '/2009/01/24/tiling-window-managers/'
    r301 '/tag/xdg/', '/2011/02/03/vim-respect-xdg/'
    r301 '/work/conquering-the-miserable-programmer-paradox/', '/2011/01/22/conquering-the-miserable-programmer-paradox/'
    r301 '/work/taking-off-and-landing/', '/2010/08/14/taking-off-and-landing/'
    # Additions
    r301 %r{/gallery/(.*)}, '/'
end

# Create, configure and start a toto instance {{{1
toto = Toto::Server.new do
    set :author, "Tom Vincent"
    set :title, "tlvince"
    set :desc, "Essays on hacking, travel and self-improvement"
    set :disqus, "tlvince"

    # Human-readble date format, e.g.: 8th April 2011
    set :date, lambda {|now| now.strftime("#{now.day}<sup>#{now.day.ordinal}</sup> %B, %Y") }
    set :error do |code|
        File.read("templates/pages/404.html")
    end
end

run toto
