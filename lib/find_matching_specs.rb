class FindMatchingSpecs
  attr_reader :directory, :files

  RUBY_FILE_EXTENSION = '.rb'.freeze
  SPEC_PREFIX_AND_EXTENSION = '_spec.rb'.freeze

  def initialize(files)
    @files = files
    @directory = directory
  end

  def call
    ruby_files = files.select { |filename| ruby_file?(filename) }
    spec_files = ruby_files.map { |filename| specs_for(filename) }

    spec_files.compact.uniq
  end

  private

  def spec_file_listing
    @spec_file_listing ||= Dir.glob("**/spec/**/*#{SPEC_PREFIX_AND_EXTENSION}")
  end

  def ruby_file?(filename)
    filename.end_with?(RUBY_FILE_EXTENSION)
  end

  def spec_file?(filename)
    filename.end_with?(SPEC_PREFIX_AND_EXTENSION)
  end

  def specs_for(filename)
    return [filename, filename] if spec_file?(filename)

    spec_match = spec_file_listing.detect do |spec_file|
      file_for_spec = spec_file.gsub(/\/?spec\//, '/')
      file_for_spec.sub!(SPEC_PREFIX_AND_EXTENSION, RUBY_FILE_EXTENSION)
      file_for_spec.sub!(/^\//, '')

      file_for_spec == filename
    end

    [filename, spec_match] unless spec_match.nil?
  end
end