require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'
PadrinoTasks.init

RSpec::Core::RakeTask.new(:selenium) do |spec|
  spec.pattern = 'selenium/*_spec.rb'
  spec.rspec_opts = ['--color']
end
