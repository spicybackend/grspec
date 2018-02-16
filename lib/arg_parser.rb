require 'optparse'

Options = Struct.new(:spec_regex)

class ArgParser
  def self.parse(options)
    args = Options.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: grspec [git ref] [git ref] [options]"

      opts.on("-rSPEC_REGEX", "--regex=SPEC_REGEX", Regexp, "Regex to filter specs") do |regex|
        args.spec_regex = regex
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

# options = Parser.parse %w[HEAD HEAD~1 -r /**\/(psuk|core|spec)\/**/*/]
# p options
