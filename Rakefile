require 'github_changelog_generator/task'

task :default => [:spec]
desc 'run RSpec'

task :spec do
  sh 'rspec spec'
end

task :build do
  sh 'gem build grspec.gemspec'
end

GitHubChangelogGenerator::RakeTask.new :changelog

task :package do
  Rake::Task["spec"].execute
  Rake::Task["build"].execute
  Rake::Task["changelog"].execute
end
