require 'spec_helper'
require './lib/find_changed_files'
require './spec/support/temp_git_directory_support'

RSpec.describe FindChangedFiles::SimpleDiff do
  include TempGitDirectorySupport

  let(:base_ref) { nil }
  let(:diff_ref) { nil }

  let(:changed_files) do
    FindChangedFiles::SimpleDiff.new(
      base_ref: base_ref,
      diff_ref: diff_ref
    ).call
  end

  describe '#call' do
    before do
      `git init`
    end

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
end