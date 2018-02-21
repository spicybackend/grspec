require 'rake'

Gem::Specification.new do |spec|
  spec.name        = 'grspec'
  spec.version     = '0.3.1'
  spec.date        = '2018-02-21'
  spec.executables << 'grspec'
  spec.summary     = 'A simple spec runner for differed files'
  spec.description = 'GRSpec is a tiny gem that can quickly and easily run specs for files that git has detected changes for, allowing for quick and easy regression checking without full-on test runs before committing and overloading build nodes.'
  spec.authors     = ['Jordane Lew']
  spec.email       = 'jordane.lew@gmail.com'
  spec.files       = FileList[
                       'bin/grspec',
                       'lib/**/*'
                     ]
  spec.homepage    = 'https://rubygems.org/gems/grspec'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.2.2'
  spec.metadata    = {
    "source_code_uri" => "https://github.com/yumoose/grspec",
    "changelog_uri"   => "https://github.com/yumoose/grspec/blob/master/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/yumoose/grspec/issues",
  }
end
