require 'rubygems'
require 'hoe'
require './lib/publisher.rb'
require 'rake'
require 'rake/testtask'

task :default => [ :test ]

desc "Run the unit tests in test"
Rake::TestTask.new("test") { |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
}

#
# Hoe stuff: rubyforge project release
#
Hoe.new('publisher', Publisher::VERSION) do |p|
  p.rubyforge_name = 'atomicobjectrb'
  p.author = 'Atomic Object'
  p.email = 'dev@atomicobject.com'
  p.summary = 'Event subscription and firing mechanism'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 1).first.gsub(/\* /,'').split(/\n/)
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

#
# Documentation
#
# Alter publish_docs to rearrange the doc directory to contain the project
# homepage, and move doc one level down, into rdoc
task :publish_docs => :setup_homepage
# nodoc 
task :setup_homepage => [ :clean, :redocs ] do
  mv "doc", "rdoc"
  cp_r "homepage", "doc"
  Find.find("doc") do |f|
    if File.basename(f) == ".svn"
      puts "Killing #{f}"
      rm_rf f
      Find.prune
    elsif f =~ /(\.erb$|\.graffle$)/
      puts "Killing #{f}"
      rm f
    end
  end
  mv "rdoc", "doc"
end

#
# Release tagging
#
desc "Tag the current release in svn AND update the 'current' release tag"
task :tag_release do
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"
  package = "publisher"
  tags = "svn+ssh://#{host}/var/svn/atomicobjectrb/tags" 
  version = Publisher::VERSION
  sh "svn cp . #{tags}/#{package}-#{version} -m 'Releasing #{package}-#{version}'"
  begin
    sh "svn del #{tags}/#{package} -m 'Preparing to update current release tag for #{package}'"
  rescue Exception
    puts "(didn't delete previous current tag)"
  end
  sh "svn cp . #{tags}/#{package} -m 'Updating current release tag for #{package} to version #{version}'"
end
