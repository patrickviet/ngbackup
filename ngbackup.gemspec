$:.push File.expand_path("../lib", __FILE__)
require 'ngbackup/version'

Gem::Specification.new do |s|
  s.name          = "ngbackup"
  s.version       = NGBackup::VERSION
  s.authors       = ["Patrick Viet"]
  s.email         = ["patrick.viet@gmail.com"]
  s.description   = %q{ngbackup tool}
  s.summary       = %q{no summary}
  s.homepage      = "https://github.com/patrickviet/ngbackup"

  s.files         = `git ls-files`.split($/).select{|f| f.start_with? 'lib/' or f.start_with? 'bin/' }
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'json',    '>= 1.7.7'
  s.add_runtime_dependency 'eventmachine', '>= 1.0.7'
  s.add_runtime_dependency 'em_pessimistic', '>= 0.2.0'
  s.add_runtime_dependency 'pry'

#  s.add_development_dependency 'pry'
end
