# GRSpec
[![Gem Version](https://badge.fury.io/rb/grspec.svg)](https://badge.fury.io/rb/grspec)
[![Build Status](https://travis-ci.org/yumoose/grspec.svg?branch=master)](https://travis-ci.org/yumoose/grspec)

A simple spec runner for differed files

## Description
GRSpec is a tiny gem that can quickly and easily run specs for files that git has detected changes for, allowing for quick and easy regression checking without full-on test runs before committing and overloading build nodes.

## Example Usage
### Simple
To run over files changed between the last commit and the current git diff, simply run `grspec` at the root of the project.

### Advanced
grspec uses `git diff` under the covers to determine which files have been changed. Args passed into `grspec` will then be passed into `git diff`, allowing for more control over the range of files and specs to be run.

As an example, `grspec HEAD~5 HEAD` will run `grspec` over the diff of the last 5 commits.

## Contributing
### Submitting Changes
1. Fork your own version of the repo
2. Create your feature branch
3. Commit and push your changes
4. Create new Pull Request

Please include a decent description as to the problem you are solving for bug fixes, and the use-case you are supporting for new features and changes.

### Requesting Features and Reporting Bugs
GitHub's issue tracker can be used to create new features and bugs, as well as track their progress.
