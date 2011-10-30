require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'
PadrinoTasks.init

RSpec::Core::RakeTask.new(:selenium) do |spec|
  spec.pattern = 'selenium/*_spec.rb'
  spec.rspec_opts = %w(-fs --color)
end

task :travis do
  ["rake spec", "rake selenium"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end
