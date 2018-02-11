class SpecRunner
  RSPEC_COMMAND = 'rspec'.freeze

  def self.run(matching_specs)
    if matching_specs.any?
      exec "#{RSPEC_COMMAND} #{matching_specs.join(' ')}"
    else
      puts "No matching specs found"
    end
  end
end
