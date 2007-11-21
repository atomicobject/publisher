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
#  p.url = p.paragraphs_of('README.txt', 1).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
end

# vim: syntax=Ruby
