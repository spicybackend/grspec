require 'spec_helper'
require 'English'
require './spec/support/temp_git_directory_support'

describe 'GRSpec binary' do
  include TempGitDirectorySupport

  let(:args) { nil }
  let(:stringy_args) { args ? args.join(' ') : nil }

  let(:grspec) { `ruby -Ilib ../bin/grspec #{stringy_args}` }

  let(:file) { 'file' }
  let(:another_file) { 'another_file' }

  before do
    setup_simple_git_repo([
      [file],
      [another_file]
    ])
  end

  context 'given no args' do
    it 'runs successfully' do
      grspec

      expect($CHILD_STATUS).to be_success
    end
  end

  context 'given a single ref arg' do
    let(:args) { ['HEAD'] }

    it 'runs successfully' do
      grspec

      expect($CHILD_STATUS).to be_success
    end
  end

  context 'given two ref args' do
    let(:args) { ['HEAD~2', 'HEAD'] }

    it 'runs successfully' do
      grspec

      expect($CHILD_STATUS).to be_success
    end
  end
end
