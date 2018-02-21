require 'spec_helper'
require './spec/support/temp_git_directory_support'
require './lib/spec_runner'

RSpec.describe SpecRunner do
  include TempGitDirectorySupport

  let(:spec_files) { Array.new }
  let(:runner) { described_class }
  let(:run) { described_class.run(spec_files) }

  describe '.run' do
    context 'there are matching spec(s) to run' do
      before do
        spec_files.each do |spec_file|
          `touch #{spec_file}`
        end
      end

      let(:spec_file) { 'file_spec.rb' }
      let(:spec_files) { [ spec_file ] }

      it 'runs the specs' do
        expect(runner).to receive(:system).with("rspec #{spec_file}")

        run
      end

      context 'multiple specs' do
        let(:another_spec_file) { 'another_file_spec.rb' }
        let(:spec_files) { [ spec_file, another_spec_file ] }

        it 'runs the specs' do
          expect(runner).to receive(:system).with("rspec #{spec_file} #{another_spec_file}")

          run
        end
      end
    end

    context 'there are no matching specs to run' do
      it 'does not execute rspec' do
        expect(runner).to_not receive(:system).with(anything)
      end
    end
  end
end
