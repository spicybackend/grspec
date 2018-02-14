class FindChangedFiles
  class GitDiffError < StandardError; end

  attr_reader :args

  GIT_DIFF_COMMAND = 'git diff'.freeze
  GIT_DIFF_OPTIONS = '--name-only'.freeze
  REDIRECT_STDERR_TO_STDOUT = '2>&1'.freeze

  def initialize(args)
    @args = args
  end

  def call
    changed_files = differed_files

    if simple_diff?
      changed_files += untracked_files
      changed_files += staged_files
    end

    changed_files
  end

  private

  def simple_diff?
    args.none?
  end

  def stringified_args
    args.join(' ')
  end

  def differed_files
    @differed_files ||= begin
      diff_output = `#{GIT_DIFF_COMMAND} #{stringified_args} #{GIT_DIFF_OPTIONS} #{REDIRECT_STDERR_TO_STDOUT}`

      raise GitDiffError.new("Bad git diff arguments; #{stringified_args}") unless $?.success?

      diff_output.split("\n")
    end
  end

  def untracked_files
    `git ls-files . --exclude-standard --others`.split("\n")
  end

  def staged_files
    `#{GIT_DIFF_COMMAND} --staged #{GIT_DIFF_OPTIONS}`.split("\n")
  end
end
