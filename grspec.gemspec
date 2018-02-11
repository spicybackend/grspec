Gem::Specification.new do |s|
  s.name        = 'grspec'
  s.version     = '0.0.1'
  s.date        = '2018-02-11'
  s.executables << 'grspec'
  s.summary     = 'Quickly check for regressions between commits'
  s.description = 'A tiny gem to run specs for files changed in git diffs'
  s.authors     = ['Jordane Lew']
  s.email       = 'jordane.lew@gmail.com'
  s.files       = ['bin/grspec', 'lib/find_changed_files.rb', 'lib/find_matching_specs.rb', 'lib/spec_runner.rb']
  s.homepage    = 'https://rubygems.org/gems/grspec'
  s.license     = 'MIT'
end