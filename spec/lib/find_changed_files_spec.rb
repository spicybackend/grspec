require 'spec_helper'
require './lib/find_changed_files'
require './spec/support/run_inside_temp_dir_support'

RSpec.describe FindChangedFiles do
  include RunInsideTempDirSupport

  let(:args) { [] }
  let(:changed_files) { FindChangedFiles.new(args).call }

  before do
    `git init`  # blank canvas for testing
  end

  describe '#call' do
    context 'finding files over a simple diff' do
      context 'with no diff between files' do
        it 'finds no changed files' do
          expect(changed_files).to be_empty
        end
      end

      context 'when a new untracked file exists' do
        let(:temp_file) { 'temp_file' }

        before { `touch temp_file` }
        after  { `rm temp_file` }

        it 'finds the untracked file change' do
          expect(changed_files).to include temp_file
        end

        context 'and the file is ignored' do
          before { `echo '#{temp_file}' > .gitignore` }

          it 'skips the ignored file' do
            expect(changed_files).to_not include temp_file
          end
        end

        context 'and the file is staged' do
          before { `git add #{temp_file}` }

          it 'finds the staged file' do
            expect(changed_files).to include temp_file
          end

          context 'and then the file is modified' do
            before { `echo 'contents' >> #{temp_file}` }

            it 'finds the modified file' do
              expect(changed_files).to include temp_file
            end
          end

          context 'and then the file is committed' do
            before { `git commit -m 'file updated'` }

            it 'skips the committed file' do
              expect(changed_files).to_not include temp_file
            end

            context 'and then the file is modified' do
              before { `echo 'contents' >> #{temp_file}` }

              it 'finds the modified file' do
                expect(changed_files).to include temp_file
              end
            end
          end
        end
      end
    end

    context 'finding files with diff arguments specified' do
      let(:initial_file) { 'initial_file' }

      before do
        `touch #{initial_file}`
        `git add ./#{initial_file}`
        `git commit -m 'added #{initial_file}'`
      end

      context 'as a range' do
        let(:args) { [ 'HEAD~5', 'HEAD' ] }

        context 'a bad git diff range' do
          it 'raises a GitDiffError' do
            expect { changed_files }.to raise_exception(FindChangedFiles::GitDiffError, /git diff arguments; #{args.join(' ')}/)
          end
        end

        context 'a diff range that exists' do
          let(:file) { 'file' }
          let(:another_file) { 'another_file' }
          let(:args) { [ 'HEAD', 'HEAD^' ] }

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
            let(:args) { [ 'HEAD~2', 'HEAD~1' ] }

            it 'finds files modified in the commit before last' do
              expect(changed_files).to include file
            end
          end

          context 'between HEAD~2 and HEAD' do
            let(:args) { [ 'HEAD~2', 'HEAD' ] }

            it 'finds files modified in the last two commits' do
              expect(changed_files).to include(file, another_file)
            end
          end
        end
      end
    end
  end
end