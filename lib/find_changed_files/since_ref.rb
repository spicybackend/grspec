class FindChangedFiles::SinceRef < FindChangedFiles
  attr_reader :base_ref

  CURRENT_REF = 'HEAD'

  def initialize(base_ref:)
    @base_ref = base_ref
  end

  def call
    changed_files_between_commits +
      changed_files_in_diff
  end

  private

  def changed_files_in_diff
    SimpleDiff.new.call
  end

  def changed_files_between_commits
    BetweenRefs.new(
      base_ref: base_ref,
      diff_ref: CURRENT_REF
    ).call
  end
end
