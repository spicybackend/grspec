module OutputSuppressionSupport
  def self.included(base)
    base.class_eval do
      around do |example|
        suppress_output
        example.run
        restore_output
      end
    end
  end

  private

  def suppress_output
    @original_stderr = $stderr
    @original_stdout = $stdout

    $stderr = File.new(File.join(File.dirname('/'), 'dev', 'null'), 'w')
    $stdout = File.new(File.join(File.dirname('/'), 'dev', 'null'), 'w')
  end

  def restore_output
    $stderr = @original_stderr
    $stdout = @original_stdout

    @original_stderr = nil
    @original_stdout = nil
  end
end