require 'spec_helper'
require 'fileutils'

require './spec/support/temp_git_directory_support'
require './lib/find_matching_specs'

RSpec.describe FindMatchingSpecs do
  include TempGitDirectorySupport

  let(:test_dirs) { [ 'spec' ] }

  let(:files) { Array.new }
  let(:specs) { Array.new }

  let(:matcher) { described_class.new(files) }

  def create_temp_file(filename)
    File.new(filename, 'w')
  end

  before do
    test_dirs.each do |dir|
      Dir.mkdir(dir) unless Dir.exists?(dir)
    end

    (files + specs).each { |filename| create_temp_file(filename) }
  end

  describe '#call' do
    subject(:matching_specs) { matcher.call }

    context 'no files to match' do
      it 'returns no matching specs' do
        expect(matching_specs).to be_empty
      end
    end

    context 'a single file to match' do
      context 'that has a matching spec' do
        let(:files) { [ 'file.rb' ] }
        let(:specs) { [ 'spec/file_spec.rb' ] }

        it 'matches the spec file' do
          expect(matching_specs).to include specs.first
        end

        context 'that is not a ruby file' do
          let(:files) { [ 'file.js' ] }

          it 'does not match the spec' do
            expect(matching_specs).to_not include specs.first
          end
        end
      end

      context 'that is a spec itself' do
        let(:files) { [ 'spec/file_spec.rb' ] }

        it 'matches the spec with itself' do
          expect(matching_specs).to include files.first
        end
      end

      context 'that has no matching spec' do
        let(:files) { [ 'file.rb' ] }

        it 'returns no matching specs' do
          expect(matching_specs).to be_empty
        end
      end

      context 'when the file and spec are nested' do
        let(:test_dirs) { [ 'app', 'spec', 'spec/app' ] }

        let(:files) { [ 'app/file.rb' ] }
        let(:specs) { [ 'spec/app/file_spec.rb' ]}

        it 'matches the spec file' do
          expect(matching_specs).to include specs.first
        end
      end

      context 'when the file and spec are located inside a sub-directory' do
        let(:test_dirs) { [ 'spec', 'sub', 'sub/spec' ] }

        let(:files) { [ 'sub/file.rb' ] }
        let(:specs) { [ 'sub/spec/file_spec.rb' ] }

        it 'matches the spec file' do
          expect(matching_specs).to include specs.first
        end

        context 'and the spec sub-directory is different' do
          let(:test_dirs) { [ 'sub', 'sup', 'sup/spec' ] }

          let(:specs) { [ 'sup/spec/file_spec.rb' ] }

          it 'returns no matching specs' do
            expect(matching_specs).to be_empty
          end
        end

        context 'and the spec is nested another level further' do
          let(:test_dirs) { [ 'sub', 'sub/spec', 'sub/spec/sub' ] }

          let(:specs) { [ 'sub/spec/sub/file_spec.rb' ] }

          it 'returns no matching specs' do
            expect(matching_specs).to be_empty
          end
        end
      end
    end

    context 'multiple files to match' do
      context 'when one file has a matching spec' do
        let(:files) { [ 'some.rb', 'file.rb' ] }
        let(:specs) { [ 'spec/some_spec.rb' ] }

        it 'matches the spec for the tested file' do
          expect(matching_specs).to include 'spec/some_spec.rb'
        end
      end

      context 'when both files have matching specs' do
        let(:files) { [ 'some.rb', 'file.rb' ] }
        let(:specs) { [ 'spec/some_spec.rb', 'spec/file_spec.rb' ] }

        it 'matches specs for both files' do
          specs.each do |spec|
            expect(matching_specs).to include spec
          end
        end

        context 'but one is not a ruby file' do
          let(:files) { [ 'some.txt', 'file.rb' ] }

          it 'returns matching specs for ruby files' do
            expect(matching_specs).to include 'spec/file_spec.rb'
          end

          it 'does not match specs for non-ruby files' do
            expect(matching_specs).to_not include 'spec/some_spec.rb'
          end
        end
      end

      context 'when neither file has a matching spec' do
        let(:files) { [ 'some.txt', 'files.rb' ] }

        it 'returns no matching specs' do
          expect(matching_specs).to be_empty
        end
      end
    end
  end
end