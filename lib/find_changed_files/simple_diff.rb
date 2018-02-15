class FindChangedFiles::SimpleDiff < FindChangedFiles
  def call
    differed_files +
    untracked_files +
    staged_files
  end

  private

  def differed_files
    `#{GIT_DIFF_COMMAND} #{GIT_DIFF_OPTIONS} #{REDIRECT_STDERR_TO_STDOUT}`.split("\n")
  end

  def untracked_files
    `git ls-files . --exclude-standard --others`.split("\n")
  end

  def staged_files
    `#{GIT_DIFF_COMMAND} --staged #{GIT_DIFF_OPTIONS}`.split("\n")
  end
end