require 'spec_helper'
require './lib/spec_runner'

RSpec.describe SpecRunner do
  let(:spec_files) { Array.new }
  let(:runner) { described_class }
  let(:run) { described_class.run(spec_files) }

  describe '.run' do
    context 'there are matching specs to run' do
      let(:spec_file) { 'spec/file' }
      let(:spec_files) { [ spec_file ] }

      it 'executes rspec with the spec filename' do
        expect(runner).to receive(:exec).with("rspec #{spec_file}")

        run
      end

      context 'multiple specs' do
        let(:another_spec_file) { 'spec/another/file' }
        let(:spec_files) { [ spec_file, another_spec_file ] }

        it 'executes rspec with the spec filenames' do
          expect(runner).to receive(:exec).with("rspec #{spec_file} #{another_spec_file}")

          run
        end
      end
    end

    context 'there are no matching specs to run' do
      it 'does not execute rspec' do
        expect(runner).to_not receive(:exec).with(anything)
      end
    end
  end
end