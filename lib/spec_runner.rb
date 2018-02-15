class SpecRunner
  RSPEC_COMMAND = 'rspec'.freeze

  def self.run(matching_specs)
    specs_to_run, removed_files = matching_specs.partition { |spec_file| File.file?(spec_file) }

    system "#{RSPEC_COMMAND} #{specs_to_run.join(' ')}" if specs_to_run.any?

    [specs_to_run, removed_files]
  end
end
