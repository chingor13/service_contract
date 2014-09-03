namespace :avro do
  desc 'build definitions'
  task :build do
    jar_file = File.expand_path("../../../src/avro-tools-1.7.7.jar", __FILE__)
    spec_dir = File.expand_path(".")
    Dir.glob(File.join(spec_dir, "/**/*.avdl")) do |file|
      puts file
      folder = File.expand_path(File.join(File.dirname(file), "../compiled"))
      FileUtils.mkdir_p(folder)
      new_file = File.join(folder, File.basename(file, ".avdl"))
      command = "java -jar #{jar_file} idl #{file} #{new_file}.avpr"
      puts command
      `#{command}`
    end
  end
end
