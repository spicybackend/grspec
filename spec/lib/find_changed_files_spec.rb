require 'spec_helper'
require './lib/find_changed_files'
require './spec/support/run_inside_temp_dir_support'

RSpec.describe FindChangedFiles do
  include RunInsideTempDirSupport

  let(:base_ref) { nil }
  let(:diff_ref) { nil }

  let(:changed_files) do
    FindChangedFiles.new(
      base_ref: base_ref,
      diff_ref: diff_ref
    ).call
  end

  let(:mock_file_changes) { ['some', 'files'] }

  describe '#call' do
    context 'when no references are given' do
      let(:mock_changed_files_strategy) { instance_double(FindChangedFiles::SimpleDiff, call: mock_file_changes) }

      it 'runs a check for files in the diff' do
        expect(FindChangedFiles::SimpleDiff).to receive(:new).and_return(mock_changed_files_strategy)

        expect(changed_files).to eq mock_file_changes
      end
    end

    context 'with just a base reference' do
      let(:base_ref) { 'some' }

      let(:mock_changed_files_strategy) { instance_double(FindChangedFiles::SinceRef, call: mock_file_changes) }

      it 'runs a check for files in the diff' do
        expect(FindChangedFiles::SinceRef).to receive(:new).and_return(mock_changed_files_strategy)

        expect(changed_files).to eq mock_file_changes
      end
    end

    context 'with base and diff references' do
      let(:base_ref) { 'some' }
      let(:diff_ref) { 'refs' }

      let(:mock_changed_files_strategy) { instance_double(FindChangedFiles::BetweenRefs, call: mock_file_changes) }

      it 'runs a check for files in the diff' do
        expect(FindChangedFiles::BetweenRefs).to receive(:new).
          with(
            base_ref: base_ref,
            diff_ref: diff_ref
          ).and_return(mock_changed_files_strategy)

        expect(changed_files).to eq mock_file_changes
      end
    end

    context 'with just a diff reference' do
      let(:diff_ref) { 'ref' }

      it 'raises an argument error' do
        expect { changed_files }.to raise_exception(ArgumentError, /base ref must be supplied/)
      end
    end
  end
end