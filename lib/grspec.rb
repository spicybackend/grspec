require 'active_support/core_ext/array/access'

require_relative '../lib/find_changed_files'
require_relative '../lib/find_matching_specs'
require_relative '../lib/spec_runner'

class Grspec
  attr_reader :base_ref, :diff_ref, :options

  def initialize(base_ref:, diff_ref:, options: OpenStruct.new)
    @base_ref = base_ref
    @diff_ref = diff_ref
    @options = options
  end

  def run
    display("No changed files found") && return if changed_files.empty?

    display_listing('Changed files:', changed_files)

    display_listing(
      'Files without specs:',
      mismatching_files.map(&:first)
    ) if mismatching_files.any?

    if matching_specs.any?
      display_listing(
        'Matching specs:',
        matching_specs.map { |matching_spec| matching_spec.join(' -> ') }
      )

      if dry_run?
        puts matching_specs.map(&:second).uniq
      else
        SpecRunner.run(matching_specs.map(&:second).uniq)
      end
    else
      display("No matching specs found")
    end
  end

  private

  def dry_run?
    options.dry_run
  end

  def changed_files
    @changed_files ||= FindChangedFiles.new(
      base_ref: base_ref,
      diff_ref: diff_ref
    ).call
  end

  def file_spec_pairs
    @file_spec_pairs ||= FindMatchingSpecs.new(changed_files).call
  end

  def mismatching_files
    @mismatching_files ||= file_spec_pairs.select { |_, spec| spec.nil? }
  end

  def matching_specs
    @matching_specs ||= file_spec_pairs - mismatching_files
  end

  def display_output?
    !dry_run?
  end

  def display(string)
    return unless display_output?

    puts
    puts string
  end

  def display_listing(header, listing)
    return unless display_output?

    puts
    puts header
    puts listing
  end
end
