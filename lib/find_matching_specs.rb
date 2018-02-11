class FindMatchingSpecs
  attr_reader :directory, :files

  RUBY_FILE_EXTENSION = '.rb'

  def initialize(files, directory: nil)
    @files = files
    @directory = directory
  end

  def call
    ruby_files = files.select { |filename| ruby_file?(filename) }
    spec_files = ruby_files.map { |filename| specs_for(filename) }.flatten

    spec_files.compact.uniq
  end

  private

  def directory
    @directory ||= Dir.pwd
  end

  def spec_file_listing
    @spec_file_listing ||= Dir.glob("#{directory}/spec/**/*")
  end

  def ruby_file?(filename)
    filename.end_with?(RUBY_FILE_EXTENSION)
  end

  def specs_for(filename)
    file = filename.split(RUBY_FILE_EXTENSION).first

    spec_file_listing.select do |spec_file|
      spec_file.match(/#{file}/)
    end
  end
end