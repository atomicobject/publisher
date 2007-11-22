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

Hoe.new('publisher', Publisher::VERSION) do |p|
  p.rubyforge_name = 'atomicobjectrb'
  p.author = 'Atomic Object'
  p.email = 'dev@atomicobject.com'
  p.summary = 'Event subscription and firing mechanism'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 1).first.gsub(/\* /,'').split(/\n/)
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

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

task :publish_docs => :setup_homepage



#Rake::Task['publish_docs'].instance_variable_get("@actions").clear
#task :publish_docs => :setup_homepage do 
#  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
#  host = "#{config["username"]}@rubyforge.org"
#
#  remote_dir = "/var/www/gforge-projects/#{rubyforge_name}/#{remote_rdoc_dir}"
#  local_dir = 'doc'
#
#  sh %{rsync #{rsync_args} #{local_dir}/ #{host}:#{remote_dir}}
#end

#    desc "Publish RDoc to RubyForge"
#    task :publish_docs => [:clean, :docs] do
#      config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
#      host = "#{config["username"]}@rubyforge.org"
#
#      remote_dir = "/var/www/gforge-projects/#{rubyforge_name}/#{remote_rdoc_dir}"
#      local_dir = 'doc'
#
#      sh %{rsync #{rsync_args} #{local_dir}/ #{host}:#{remote_dir}}
#    end
