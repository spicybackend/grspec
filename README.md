# GRSpec
[![GitHub release](https://img.shields.io/github/release/yumoose/grspec.svg)](https://github.com/yumoose/grspec/releases/)
[![Build Status](https://travis-ci.org/yumoose/grspec.svg?branch=master)](https://travis-ci.org/yumoose/grspec)
[![Gem](https://img.shields.io/gem/v/grspec.svg)](https://rubygems.org/gems/grspec)
[![Gem](https://img.shields.io/gem/dt/grspec.svg)](https://rubygems.org/gems/grspec)

A simple spec runner for differed files

## Description
GRSpec is a tiny gem that can quickly and easily run specs for files that git has detected changes for, allowing for quick and easy regression checking without full-on test runs before committing and overloading build nodes.

## Installation
`gem install grspec`

## Example Usage
### Simple
To run over files changed between the last commit and the current git diff, simply run `grspec` at the root of the project.

```
$ grspec

Changed files:
CHANGELOG.md
lib/grspec.rb

Matching specs:
lib/grspec.rb -> spec/lib/grspec_spec.rb
.....................

Finished in 2.77 seconds (files took 0.28235 seconds to load)
21 examples, 0 failures
```

### Running Changes Since a Reference
`grspec HEAD~5` will run `grspec` over the diff of the last 5 commits.

### Running Changes Between References
`grspec master develop` will run `grspec` over the diff between the `master` and `develop` branches. To avoid running changes that exist in the `master` branch that aren't present in the `develop` branch, a merge-base is used to diff those files changed since diverging from `master`

### Dry Runs
The `grspec` binary has a convenience option to perform a simple listing of the specs for changed files without actually running them. This is useful for piping off to other programs.

For example
```
$ grspec -d HEAD~5 | grep 'spec/'
spec/lib/grspec_spec.rb
spec/lib/spec_runner_spec.rb

$ grspec -d master HEAD | grep 'spec/lib/' | grspec
...
```

## Contributing
### Submitting Changes
1. Fork your own version of the repo
2. Create your feature branch
3. Commit and push your changes
4. Create new Pull Request

Please include a decent description as to the problem you are solving for bug fixes, and the use-case you are supporting for new features and changes.

### Requesting Features and Reporting Bugs
GitHub's issue tracker can be used to create new features and bugs, as well as track their progress.
