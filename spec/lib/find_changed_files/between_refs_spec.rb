require 'spec_helper'
require './lib/find_changed_files'
require './spec/support/run_inside_temp_dir_support'

RSpec.describe FindChangedFiles::BetweenRefs do
  include RunInsideTempDirSupport

  let(:base_ref) { nil }
  let(:diff_ref) { nil }

  let(:changed_files) do
    FindChangedFiles::BetweenRefs.new(
      base_ref: base_ref,
      diff_ref: diff_ref
    ).call
  end

  describe '#call' do
    before do
      `git init`
    end

    let(:initial_file) { 'initial_file' }

    before do
      `touch #{initial_file}`
      `git add ./#{initial_file}`
      `git commit -m 'added #{initial_file}'`
    end

    context 'as a range' do
      let(:base_ref) { 'HEAD~5' }
      let(:diff_ref) { 'HEAD' }

      context 'a bad git diff range' do
        it 'raises a GitDiffError' do
          expect { changed_files }.to raise_exception(ArgumentError, /git diff arguments; #{base_ref} #{diff_ref}/)
        end
      end

      context 'a diff range that exists' do
        let(:file) { 'file' }
        let(:another_file) { 'another_file' }

        let(:base_ref) { 'HEAD~1' }
        let(:diff_ref) { 'HEAD' }

        before do
          `touch #{file}`
          `git add ./#{file}`
          `git commit -m 'added #{file}'`

          `touch #{another_file}`
          `git add ./#{another_file}`
          `git commit -m 'added #{another_file}'`
        end

        context 'between HEAD~1 and HEAD' do
          it 'finds files modified in the most recent commit' do
            expect(changed_files).to include another_file
          end
        end

        context 'between HEAD~2 and HEAD~1' do
          let(:base_ref) { 'HEAD~2' }
          let(:diff_ref) { 'HEAD~1' }

          it 'finds files modified in the commit before last' do
            expect(changed_files).to include file
          end
        end

        context 'between HEAD~2 and HEAD' do
          let(:base_ref) { 'HEAD~2' }
          let(:diff_ref) { 'HEAD' }

          it 'finds files modified in the last two commits' do
            expect(changed_files).to include(file, another_file)
          end
        end
      end
    end
  end
end