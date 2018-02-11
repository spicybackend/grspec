Gem::Specification.new do |s|
  s.name        = 'grspec'
  s.version     = '0.0.1'
  s.date        = '2018-02-11'
  s.executables << 'grspec'
  s.summary     = 'A simple spec runner for differed files'
  s.description = 'GRSpec is a tiny gem that can quickly and easily run specs for files that git has detected changes for, allowing for quick and easy regression checking without full-on test runs before committing and overloading build nodes.'
  s.authors     = ['Jordane Lew']
  s.email       = 'jordane.lew@gmail.com'
  s.files       = ['bin/grspec', 'lib/find_changed_files.rb', 'lib/find_matching_specs.rb', 'lib/spec_runner.rb']
  s.homepage    = 'https://rubygems.org/gems/grspec'
  s.license     = 'MIT'
end