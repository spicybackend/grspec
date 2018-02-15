class FindChangedFiles::BetweenRefs < FindChangedFiles
  attr_reader :base_ref, :diff_ref

  GIT_MERGE_BASE_COMMAND = 'git merge-base'.freeze

  def initialize(base_ref:, diff_ref:)
    @base_ref = base_ref
    @diff_ref = diff_ref
  end

  def call
    differed_files(merge_base_ref, diff_ref)
  end

  private

  def merge_base_ref
    merge_base = `#{GIT_MERGE_BASE_COMMAND} #{base_ref} #{diff_ref} #{REDIRECT_STDERR_TO_STDOUT}`

    raise ArgumentError.new("Bad git diff arguments; #{base_ref} #{diff_ref}") unless $?.success?

    merge_base.strip
  end

  def differed_files(from_ref, to_ref)
    @differed_files ||= begin
      diff_output = `#{GIT_DIFF_COMMAND} #{from_ref} #{to_ref} #{GIT_DIFF_OPTIONS} #{REDIRECT_STDERR_TO_STDOUT}`

      raise ArgumentError.new("Bad git diff arguments; #{base_ref} #{diff_ref}") unless $?.success?

      diff_output.split("\n")
    end
  end
end
