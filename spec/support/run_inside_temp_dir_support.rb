module RunInsideTempDirSupport
  TEMP_PATH = './tmp'

  def self.included(base)
    base.class_eval do
      around do |example|
        Dir.mkdir(TEMP_PATH) unless Dir.exists?(TEMP_PATH)
        FileUtils.rm_rf Dir.glob("#{TEMP_PATH}/**/*")

        Dir.chdir(TEMP_PATH) do
          example.run
        end

        FileUtils.rm_rf Dir.glob("#{TEMP_PATH}/**/*")
        FileUtils.rm_rf TEMP_PATH
      end
    end
  end
end