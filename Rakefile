$:.push File.join(File.dirname(__FILE__), 'lib')
$:.push File.join(File.dirname(__FILE__), 'tasks/support')

require 'rubygems'
require 'bundler/gem_tasks'
require 'rspec'
require 'rspec/core/rake_task'

require 'ratistics'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '-fd --color'
end

$:.unshift 'tasks'
Dir.glob('tasks/**/*.rake').each do|rakefile|
  load rakefile
end

#task :default => [:default_task]
