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
    spec_files = ruby_files.map { |filename| specs_for(filename) }.flatten

    spec_files.compact.uniq
  end

  private

  def spec_file_listing
    @spec_file_listing ||= Dir.glob("**/spec/**/*")
  end

  def ruby_file?(filename)
    filename.end_with?(RUBY_FILE_EXTENSION)
  end

  def specs_for(filename)
    return [filename] if filename.end_with?('_spec.rb')

    expected_name = filename.sub!(RUBY_FILE_EXTENSION, SPEC_PREFIX_AND_EXTENSION)

    spec_file_listing.select do |spec_file|
      file_for_spec = spec_file.gsub(/\/?spec\//, '/')
      file_for_spec.sub!(/^\//, '')

      file_for_spec == expected_name
    end
  end
end