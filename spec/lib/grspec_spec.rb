require 'spec_helper'

require 'ostruct'
require './spec/support/output_suppression_support'

require './lib/grspec'

RSpec.describe Grspec do
  include OutputSuppressionSupport

  let(:base_ref) { 'master_branch' }
  let(:diff_ref) { 'new_feature_branch' }
  let(:options) { OpenStruct.new }

  let(:grspec) { Grspec.new(base_ref: base_ref, diff_ref: diff_ref, options: options) }

  describe '#run' do
    let(:mock_find_changed_files_service) { instance_double(FindChangedFiles, call: mock_changed_files) }

    before do
      expect(FindChangedFiles).to receive(:new).with(
        base_ref: base_ref,
        diff_ref: diff_ref
      ).and_return(mock_find_changed_files_service)
    end

    context 'when no files have changed' do
      let(:mock_changed_files) { [] }

      it 'outputs a "no changed files" message' do
        expect { grspec.run }.to output(/No changed files found/).to_stdout
      end

      it 'does not run the spec runner' do
        expect(SpecRunner).to_not receive(:new)

        grspec.run
      end

      context 'the option is given for a dry run' do
        before do
          options.dry_run = true
        end

        it 'does not output anything' do
          expect { grspec.run }.to output(anything).to_stdout
        end
      end
    end

    context 'when there are changed files' do
      let(:changed_file) { 'changed_file.rb' }
      let(:another_changed_file) { 'another_changed_file.rb' }

      let(:mock_changed_files) { [changed_file, another_changed_file] }

      let(:mock_find_matching_specs_service) { instance_double(FindMatchingSpecs, call: mock_matching_specs) }
      let(:mock_matching_specs) { [] }

      before do
        expect(FindMatchingSpecs).to receive(:new).with(
          mock_changed_files
        ).and_return(mock_find_matching_specs_service)
      end

      it 'outputs the changed files' do
        expect { grspec.run }.to output(
          /Changed files:\n#{changed_file}\n#{another_changed_file}/
        ).to_stdout
      end

      context 'with matching specs' do
        let(:changed_file_spec) { 'spec/changed_file_spec.rb' }
        let(:another_changed_file_spec) { 'spec/another_changed_file_spec.rb' }

        let(:spec_files) { [changed_file_spec, another_changed_file_spec] }

        let(:mock_matching_specs) do
          [
            [changed_file, changed_file_spec],
            [another_changed_file, another_changed_file_spec]
          ]
        end

        it 'outputs the spec matches' do
          expected_output = ["Matching specs:"]
          expected_output += mock_matching_specs.map { |file, spec| "#{file} -> #{spec}" }

          expect { grspec.run }.to output(/#{expected_output.join("\n")}/).to_stdout
        end

        it 'runs the specs' do
          expect(SpecRunner).to receive(:run).with(spec_files)

          grspec.run
        end

        context 'the option is given for a dry run' do
          before do
            options.dry_run = true
          end

          it 'only outputs a dry run listing of spec files' do
            expect { grspec.run }.to output(/#{spec_files.join("\n")}/).to_stdout
          end

          it 'does not run the spec runner' do
            expect(SpecRunner).to_not receive(:new)

            grspec.run
          end
        end
      end

      context 'without matching specs' do
        let(:mock_matching_specs) do
          [
            [changed_file, nil],
            [another_changed_file, nil]
          ]
        end

        it 'outputs the files without matching specs' do
          expect { grspec.run }.to output(
            /Files without specs:\n#{changed_file}\n#{another_changed_file}/
          ).to_stdout
        end

        it 'does not run the spec runner' do
          expect(SpecRunner).to_not receive(:new)

          grspec.run
        end

        it 'outputs a "no matching specs" message' do
          expect { grspec.run }.to output(/No matching specs found/).to_stdout
        end
      end

      context 'some with and some without matching specs' do
        let(:changed_file_spec) { 'spec/changed_file_spec.rb' }
        let(:spec_files) { [changed_file_spec] }

        let(:mock_matching_specs) do
          [
            [changed_file, changed_file_spec],
            [another_changed_file, nil]
          ]
        end

        it 'outputs the spec matches' do
          expected_output = ["Matching specs:"]
          expected_output += mock_matching_specs.reject { |_, spec| spec.nil? }.
            map { |file, spec| "#{file} -> #{spec}" }

          expect { grspec.run }.to output(/#{expected_output.join("\n")}/).to_stdout
        end

        it 'outputs the files without matching specs' do
          expect { grspec.run }.to output(
            /Files without specs:\n#{another_changed_file}/
          ).to_stdout
        end

        it 'runs the specs' do
          expect(SpecRunner).to receive(:run).with(spec_files)

          grspec.run
        end

        context 'the option is given for a dry run' do
          it 'only outputs a dry run listing of spec files' do
            expect { grspec.run }.to output(/#{spec_files.join("\n")}/).to_stdout
          end

          it 'does not run the spec runner' do
            expect(SpecRunner).to_not receive(:new)

            grspec.run
          end
        end
      end
    end
  end
end
