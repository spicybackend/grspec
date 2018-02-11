# GRSpec
[![Build Status](https://travis-ci.org/yumoose/grspec.svg?branch=master)](https://travis-ci.org/yumoose/grspec)

A simple spec runner for differed files

## Description
GRSpec is a tiny gem that can quickly and easily run specs for files that git has detected changes for, allowing for quick and easy regression checking without full-on test runs before committing and overloading build nodes.

## Example Usage
### Simple Usage
To run over files changed between the last commit and the current git diff, simply run `grspec` at the root of the project.

### Advanced Usage
grspec uses `git diff` under the covers to determine which files have been changed. Args passed into `grspec` will then be passed into `git diff`, allowing for more control over the range of files and specs to be run.

As an example, `grspec HEAD~5 HEAD` will run `grspec` over the diff of the last 5 commits.
