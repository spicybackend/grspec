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

    xcontext 'finding files over a diff range' do
      let(:args) { [ 'HEAD~1', 'HEAD' ] }

    end
  end
end