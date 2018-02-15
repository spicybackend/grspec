module RunInsideTempDirSupport
  require 'fileutils'

  TEMP_PATH = './tmp'

  def self.included(base)
    base.class_eval do
      around do |example|
        Dir.mkdir(TEMP_PATH) unless Dir.exists?(TEMP_PATH)
        FileUtils.rm_rf Dir.glob("#{TEMP_PATH}/**/*")

        Dir.chdir(TEMP_PATH) do
          example.run
        end

        FileUtils.rm_rf Dir.glob("#{TEMP_PATH}/**/*")
        FileUtils.rm_rf TEMP_PATH
      end
    end
  end

  def setup_simple_git_repo(commits)
    `git init`

    `touch init_file`
    `git add ./init_file`
    `git commit -m 'added init_file'`

    commits.each do |files_to_commit|
      files_to_commit.each do |file|
        `touch #{file}`
        `git add ./#{file}`
      end

      `git commit -m 'added #{file}'`
    end
  end
end
