require 'spec_helper'
require './lib/find_changed_files'
require './spec/support/temp_git_directory_support'

RSpec.describe FindChangedFiles::BetweenRefs do
  include TempGitDirectorySupport

  let(:base_ref) { nil }
  let(:diff_ref) { nil }

  let(:changed_files) do
    FindChangedFiles::BetweenRefs.new(
      base_ref: base_ref,
      diff_ref: diff_ref
    ).call
  end

  describe '#call' do
    let(:base_ref) { 'HEAD~1' }
    let(:diff_ref) { 'HEAD' }

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

    context 'between the two most recent commits' do
      it 'finds files modified in the most recent commit' do
        expect(changed_files).to include another_file
      end
    end

    context 'between a range of a single commit' do
      let(:base_ref) { 'HEAD~2' }
      let(:diff_ref) { 'HEAD~1' }

      it 'finds files modified in the commit' do
        expect(changed_files).to include file
      end
    end

    context 'between a range over multiple comits' do
      let(:base_ref) { 'HEAD~2' }
      let(:diff_ref) { 'HEAD' }

      it 'finds files modified between the commits' do
        expect(changed_files).to include(file, another_file)
      end
    end

    context 'between diverged branches' do
      let(:branch_a) { 'a' }
      let(:branch_b) { 'b' }

      let(:file_in_branch_a) { 'some_file' }
      let(:file_in_branch_b) { 'some_other_file' }

      before do
        `git checkout HEAD~2 2>&1`

        `git checkout -b #{branch_a} 2>&1`
        `touch #{file_in_branch_a}`
        `git add #{file_in_branch_a}`
        `git commit -m 'added #{file_in_branch_a}'`

        `git checkout - 2>&1`

        `git checkout -b #{branch_b} 2>&1`
        `touch #{file_in_branch_b}`
        `git add #{file_in_branch_b}`
        `git commit -m 'added #{file_in_branch_b}'`
      end

      context 'when diffing from "a" to "b"' do
        let(:base_ref) { branch_a }
        let(:diff_ref) { branch_b }

        it 'finds the files changed since the divergence, present in "b"' do
          expect(changed_files).to include file_in_branch_b
        end

        it 'has no files from branch "a"' do
          expect(changed_files).to_not include file_in_branch_a
        end
      end

      context 'when diffing from "b" to "a"' do
        let(:base_ref) { branch_b }
        let(:diff_ref) { branch_a }

        it 'finds the files changed since the divergence, present in "a"' do
          expect(changed_files).to include file_in_branch_a
        end

        it 'has no files from branch "b"' do
          expect(changed_files).to_not include file_in_branch_b
        end
      end
    end

    context 'a non-existent diff range' do
      let(:base_ref) { 'HEAD~100' }
      let(:diff_ref) { 'HEAD' }

      it 'raises a GitDiffError' do
        expect { changed_files }.to raise_exception(ArgumentError, /git diff arguments; #{base_ref} #{diff_ref}/)
      end
    end
  end
end