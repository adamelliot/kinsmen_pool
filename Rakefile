require 'rubygems'
require 'rake'

load 'lib/tasks/cron.rake'

require 'micronaut/rake_task'
Micronaut::RakeTask.new(:examples) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.ruby_opts << '-Ilib -Iexamples'
end

Micronaut::RakeTask.new(:rcov) do |examples|
  examples.pattern = 'examples/**/*_example.rb'
  examples.rcov_opts = '-Ilib -Iexamples'
  examples.rcov = true
end

task :examples => :check_dependencies

begin
  require 'reek/adapters/rake_task'
  Reek::RakeTask.new do |t|
    t.fail_on_error = true
    t.verbose = false
    t.source_files = 'lib/**/*.rb'
  end
rescue LoadError
  task :reek do
    abort "Reek is not available. In order to run reek, you must: sudo gem install reek"
  end
end

begin
  require 'roodi'
  require 'roodi_task'
  RoodiTask.new do |t|
    t.verbose = false
  end
rescue LoadError
  task :roodi do
    abort "Roodi is not available. In order to run roodi, you must: sudo gem install roodi"
  end
end

task :default => :examples

desc "Loads the current calendar into the database so it can be served"
task :load_calendar do
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

  require 'kinsmen_pool'

  KinsmenPool::Mechanic.read_calendar
end
