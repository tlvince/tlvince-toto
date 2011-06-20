# Rakefile for tlvince.com
# Copyright 2011 Tom Vincent <http://www.tlvince.com/contact/>
# vim: set fdm=marker :

task :default => :build

desc "Minify assets and build pages" # {{{1
task :build do
    toto "Building pages"

    if not has_program?("pandoc")
        abort("error: requires 'pandoc' to be installed")
    end

    root = "templates/pages"
    Dir.foreach(root + "/src") do |page|
        next if page == "." or page == ".."
        html = "#{File.basename(page, ".mkd")}.rhtml" 
        `pandoc --to="html" --smart --output="#{root}/#{html}" \
            "#{root}/src/#{page}"`
    end
end

desc "Deploy to GitHub and Heroku" # {{{1
task :deploy do
    toto "Deploying to GitHub"
    `git push origin master`
    toto "Deploying to Heroku"
    `git push heroku master`
end

# Helper functions {{{1

def toto msg
    puts "toto: #{msg}\n"
end

# Author: Arto Bendiken
# http://stackoverflow.com/questions/2108727/
def has_program?(program)
    ENV['PATH'].split(File::PATH_SEPARATOR).any? do |directory|
        File.executable?(File.join(directory, program.to_s))
    end
end
