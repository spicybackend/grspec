class FindChangedFiles
  attr_reader :args

  GIT_DIFF_COMMAND = 'git diff'.freeze
  GIT_DIFF_OPTIONS = '--name-only'.freeze

  def initialize(args)
    @args = args
  end

  def call
    changed_files = differed_files
    changed_files += untracked_files if simple_diff?

    changed_files.split("\n")
  end

  private

  def simple_diff?
    args.none?
  end

  def stringified_args
    args.join(' ')
  end

  def differed_files
    `#{GIT_DIFF_COMMAND} #{stringified_args} #{GIT_DIFF_OPTIONS}`
  end

  def untracked_files
    `git ls-files . --exclude-standard --others`
  end
end