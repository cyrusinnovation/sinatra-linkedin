require "bundler/gem_tasks"
require "rake/testtask"
require "rdoc/task"

EXTRA_RDOC_FILES = ['README.rdoc']
LIB_FILES        = Dir["lib/**/*.rb"]
MAIN_RDOC        = 'README.rdoc'
TEST_FILES       = Dir["test/**/*_test.rb"]
TITLE            = 'sinatra-linkedin'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = TEST_FILES
end

RDoc::Task.new do |t|
  t.main = MAIN_RDOC
  t.rdoc_dir = 'doc'
  t.rdoc_files.include(EXTRA_RDOC_FILES, LIB_FILES)
  t.options << '-q'
  t.title = TITLE
end
