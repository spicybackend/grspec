require 'github_changelog_generator/task'

task :default => [:spec]
desc 'run RSpec'

task :spec do
  sh 'rspec spec'
end

GitHubChangelogGenerator::RakeTask.new :changelog
