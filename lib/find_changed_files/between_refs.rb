class FindChangedFiles::BetweenRefs < FindChangedFiles
  attr_reader :base_ref, :diff_ref

  GIT_MERGE_BASE_COMMAND = 'git merge-base'.freeze

  def initialize(base_ref: nil, diff_ref: nil)
    @base_ref = base_ref
    @diff_ref = diff_ref
  end

  def call
    differed_files
  end

  private

  def differed_files
    @differed_files ||= begin
      diff_output = `#{GIT_DIFF_COMMAND} #{base_ref} #{diff_ref} #{GIT_DIFF_OPTIONS} #{REDIRECT_STDERR_TO_STDOUT}`

      raise ArgumentError.new("Bad git diff arguments; #{base_ref} #{diff_ref}") unless $?.success?

      diff_output.split("\n")
    end
  end
end
