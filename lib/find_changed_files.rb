class FindChangedFiles
  GIT_DIFF_COMMAND = 'git diff'.freeze
  GIT_DIFF_OPTIONS = '--name-only'.freeze

  def initialize(args)
    @args = args
  end

  def call
    differed_files.split("\n")
  end

  private

  def stringified_args
    @args.join(' ')
  end

  def differed_files
    `#{GIT_DIFF_COMMAND} #{stringified_args} #{GIT_DIFF_OPTIONS}`
  end
end