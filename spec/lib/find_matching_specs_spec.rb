require 'spec_helper'
require 'fileutils'

require './spec/support/temp_git_directory_support'
require './lib/find_matching_specs'

RSpec.describe FindMatchingSpecs do
  include TempGitDirectorySupport

  RSpec::Matchers.define :have_no_matching_specs do
    match do |actual|
      actual.all? do |_, spec|
        spec.nil?
      end
    end
  end

  RSpec::Matchers.define :include_a_match_for do |expected_file, expected_spec|
    match do |actual|
      actual.any? do |file, spec|
        file == expected_file && spec == expected_spec
      end
    end
  end

  RSpec::Matchers.define :not_match_the_file do |expected_file|
    match do |actual|
      actual.none? { |file, _| file == expected_file }
    end
  end

  RSpec::Matchers.define :not_match_the_spec do |expected_spec|
    match do |actual|
      actual.none? { |spec, _| spec == expected_spec }
    end
  end

  let(:test_dirs) { ['spec'] }

  let(:files) { [] }
  let(:specs) { [] }

  let(:matching_service) { described_class.new(files) }

  def create_temp_file(filename)
    File.new(filename, 'w')
  end

  before do
    test_dirs.each do |dir|
      Dir.mkdir(dir) unless Dir.exist?(dir)
    end

    (files + specs).each { |filename| create_temp_file(filename) }
  end

  describe '#call' do
    subject(:matching_specs) { matching_service.call }

    context 'no files to match' do
      it 'returns no matching specs' do
        expect(matching_specs).to have_no_matching_specs
      end
    end

    context 'a single file to match' do
      let(:file) { nil }
      let(:spec) { nil }

      let(:files) { [file].compact }
      let(:specs) { [spec].compact }

      context 'that has a matching spec' do
        let(:file) { 'file.rb' }
        let(:spec) { 'spec/file_spec.rb' }

        it 'matches the spec file' do
          expect(matching_specs).to include_a_match_for(file, spec)
        end

        context 'that is not a ruby file' do
          let(:file) { 'file.js' }

          it 'does not match the spec' do
            expect(matching_specs).to_not include_a_match_for(file, spec)
          end
        end
      end

      context 'that is a spec itself' do
        let(:file) { 'spec/file_spec.rb' }
        let(:spec) { file }

        it 'matches the spec with itself' do
          expect(matching_specs).to include_a_match_for(file, spec)
        end
      end

      context 'that has no matching spec' do
        let(:file) { 'file.rb' }

        it 'returns no matching specs' do
          expect(matching_specs).to have_no_matching_specs
        end
      end

      context 'when the file and spec are nested' do
        let(:test_dirs) { ['app', 'spec', 'spec/app'] }

        let(:file) { 'app/file.rb' }
        let(:spec) { 'spec/app/file_spec.rb' }

        it 'matches the spec file' do
          expect(matching_specs).to include_a_match_for(file, spec)
        end
      end

      context 'when the file and spec are located inside a sub-directory' do
        let(:test_dirs) { ['spec', 'sub', 'sub/spec'] }

        let(:file) { 'sub/file.rb' }
        let(:spec) { 'sub/spec/file_spec.rb' }

        it 'matches the spec file' do
          expect(matching_specs).to include_a_match_for(file, spec)
        end

        context 'and the spec sub-directory is different' do
          let(:test_dirs) { ['sub', 'sup', 'sup/spec'] }
          let(:specs) { ['sup/spec/file_spec.rb'] }

          it 'returns no matching specs' do
            expect(matching_specs).to have_no_matching_specs
          end
        end

        context 'and the spec is nested another level further' do
          let(:test_dirs) { ['sub', 'sub/spec', 'sub/spec/sub'] }
          let(:spec) { 'sub/spec/sub/file_spec.rb' }

          it 'returns no matching specs' do
            expect(matching_specs).to have_no_matching_specs
          end
        end
      end
    end

    context 'multiple files to match' do
      context 'when one file has a matching spec' do
        let(:files) { ['some.rb', 'file.rb'] }
        let(:specs) { ['spec/some_spec.rb'] }

        it 'matches the spec for the tested file' do
          expect(matching_specs).to include_a_match_for(files[0], specs[0])
        end
      end

      context 'when both files have matching specs' do
        let(:files) { ['some.rb', 'file.rb'] }
        let(:specs) { ['spec/some_spec.rb', 'spec/file_spec.rb'] }

        it 'matches specs for both files' do
          files.size.times do |index|
            expect(matching_specs).to include_a_match_for(files[index], specs[index])
          end
        end

        context 'but one is not a ruby file' do
          let(:files) { ['some.txt', 'file.rb'] }

          it 'returns matching specs for ruby files' do
            expect(matching_specs).to include_a_match_for(files.last, specs.last)
          end

          it 'does not match specs for non-ruby files' do
            expect(matching_specs).to not_match_the_file('some.txt')
            expect(matching_specs).to not_match_the_spec('spec/some_spec.rb')
          end
        end
      end

      context 'when neither file has a matching spec' do
        let(:files) { ['some.txt', 'files.rb'] }

        it 'returns no matching specs' do
          expect(matching_specs).to have_no_matching_specs
        end
      end
    end
  end
end
