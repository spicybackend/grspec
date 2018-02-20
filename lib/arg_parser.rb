require 'ostruct'
require 'optparse'

class ArgParser
  def self.parse(options)
    args = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: grspec [git ref] [git ref] [options]"

      opts.on("-rSPEC_REGEX", "--regex=SPEC_REGEX", Regexp, "Regex to filter specs") do |regex|
        args.spec_regex = regex
      end

      opts.on("-d", "--dry", "Performs a dry run for a listing that would be passed through to RSpec") do
        args.dry_run = true
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)

    args
  end
end
