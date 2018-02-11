Gem::Specification.new do |s|
  s.name        = 'Git Diff RSpec'
  s.version     = '0.0.1'
  s.date        = '2018-02-11'
  s.summary     = "Quickly check for regressions between commits"
  s.description = "A tiny gem to run specs for files changed in diffs"
  s.authors     = ["Jordane Lew"]
  s.email       = 'jordane.lew@gmail.com'
  s.files       = ["bin/grspec", "lib/find_changed_files", "lib/find_matching_specs.rb", "lib/git_diff_spec.rb"]
  s.homepage    =
    'https://rubygems.org/gems/grspec'
  s.license       = 'MIT'
end