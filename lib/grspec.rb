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
    if changed_files.empty?
      display("No changed files found")
      return
    end

    display_listing('Changed files:', changed_files)

    display_listing(
      'Files without specs:',
      mismatching_files.map(&:first)
    ) if mismatching_files.any?

    if spec_matchings.any?
      display_listing(
        'Matching specs:',
        spec_matchings.map { |matching_spec| matching_spec.join(' -> ') }
      )

      if non_existent_specs.any?
        display_listing(
          'Removed specs:',
          non_existent_specs
        )
      end

      if specs_to_run.any?
        if dry_run?
          puts specs_to_run
        else
          SpecRunner.run(specs_to_run)
        end
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

  def spec_matchings
    @spec_matchings ||= file_spec_pairs - mismatching_files
  end

  def matching_specs
    @matching_specs ||= spec_matchings.map(&:second).uniq
  end

  def non_existent_specs
    @non_existent_specs ||= matching_specs.reject { |spec_file| File.file?(spec_file) }
  end

  def specs_to_run
    @specs_to_run ||= matching_specs - non_existent_specs
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
