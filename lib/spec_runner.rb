class SpecRunner
  RSPEC_COMMAND = 'rspec'.freeze

  def self.run(specs)
    system "#{RSPEC_COMMAND} #{specs.join(' ')}" if specs.any?
  end
end
