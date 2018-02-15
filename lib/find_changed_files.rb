class FindChangedFiles
  require 'active_support/core_ext/object/blank'

  require_relative 'find_changed_files/simple_diff'
  require_relative 'find_changed_files/since_ref'
  require_relative 'find_changed_files/between_refs'

  attr_reader :base_ref, :diff_ref

  GIT_DIFF_COMMAND = 'git diff'.freeze
  GIT_DIFF_OPTIONS = '--name-only'.freeze

  REDIRECT_STDERR_TO_STDOUT = '2>&1'.freeze

  def initialize(base_ref: nil, diff_ref: nil)
    @base_ref = base_ref
    @diff_ref = diff_ref
  end

  def call
    if simple_diff?
      SimpleDiff.new.call
    elsif since_ref?
      SinceRef.new(
        base_ref: base_ref
      ).call
    elsif between_refs?
      BetweenRefs.new(
        base_ref: base_ref,
        diff_ref: diff_ref
      ).call
    else
      raise ArgumentError.new('A base ref must be supplied with a diff ref')
    end
  end

  private

  def simple_diff?
    base_ref.blank? && diff_ref.blank?
  end

  def since_ref?
    base_ref.present? && diff_ref.blank?
  end

  def between_refs?
    base_ref.present? && diff_ref.present?
  end
end
