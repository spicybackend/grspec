class SpecRunner
  RSPEC_COMMAND = 'rspec'.freeze

  def self.run(matching_specs)
    exec "#{RSPEC_COMMAND} #{matching_specs.join(' ')}" if matching_specs.any?
  end
end
