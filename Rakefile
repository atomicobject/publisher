require "bundler/gem_tasks"

require 'rake/testtask'

task :default => [ :test ]

desc "Run the unit tests in test"
Rake::TestTask.new("test") { |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
}

# See crosby or fletcher about these tasks
if File.exists?("../tools/")
  load "../tools/tasks/homepage.rake"
  load "../tools/tasks/release_tagging.rake"
  ReleaseTagging.new do |t|
    t.package = "publisher"
    t.version = Publisher::VERSION
  end
end
