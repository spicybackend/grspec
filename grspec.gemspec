require 'rake'

Gem::Specification.new do |spec|
  spec.name        = 'grspec'
  spec.version     = '0.4.0'
  spec.date        = '2018-02-21'
  spec.executables << 'grspec'
  spec.summary     = "A simple spec runner for diff'd files"
  spec.description = 'GRSpec is a tool for quickly and easily running specs for files that git has detected changes for, allowing for efficient regression checks.'
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
