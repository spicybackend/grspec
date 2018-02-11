Gem::Specification.new do |spec|
  spec.name        = 'grspec'
  spec.version     = '0.0.1'
  spec.date        = '2018-02-11'
  spec.executables << 'grspec'
  spec.summary     = 'A simple spec runner for differed files'
  spec.description = 'GRSpec is a tiny gem that can quickly and easily run specs for files that git has detected changes for, allowing for quick and easy regression checking without full-on test runs before committing and overloading build nodes.'
  spec.authors     = ['Jordane Lew']
  spec.email       = 'jordane.lew@gmail.com'
  spec.files       = ['bin/grspec', 'lib/find_changed_files.rb', 'lib/find_matching_specs.rb', 'lib/spec_runner.rb']
  spec.homepage    = 'https://rubygems.org/gems/grspec'
  spec.license     = 'MIT'
  spec.metadata    = { "source_code_uri" => "https://github.com/yumoose/grspec" }
  spec.required_ruby_version = '>= 2.2.2'
end