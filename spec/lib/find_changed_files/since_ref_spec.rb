require 'spec_helper'
require './lib/find_changed_files'
require './spec/support/run_inside_temp_dir_support'

RSpec.describe FindChangedFiles::BetweenRefs do
  include RunInsideTempDirSupport

  let(:base_ref) { nil }

  let(:changed_files) do
    FindChangedFiles::SinceRef.new(base_ref: base_ref).call
  end

  describe '#call' do
    let(:base_ref) { 'HEAD~1' }

    let(:initial_file) { 'initial_file' }
    let(:file) { 'file' }
    let(:another_file) { 'another_file' }

    before do
      `git init`

      `touch #{initial_file}`
      `git add ./#{initial_file}`
      `git commit -m 'added #{initial_file}'`

      `touch #{file}`
      `git add ./#{file}`
      `git commit -m 'added #{file}'`

      `touch #{another_file}`
      `git add ./#{another_file}`
      `git commit -m 'added #{another_file}'`
    end

    context 'since the current commit' do
      let(:base_ref) { 'HEAD' }

      it 'finds files modified in the commit' do
        expect(changed_files).to be_empty
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
              # Still HEAD <-> HEAD. No difference.
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

    context 'since two commits ago' do
      let(:base_ref) { 'HEAD~2' }

      it 'finds files modified between the commits' do
        expect(changed_files).to include(file, another_file)
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

            it 'finds the committed file' do
              expect(changed_files).to include temp_file
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
end