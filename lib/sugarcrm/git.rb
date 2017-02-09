require 'fileutils'
require_relative 'ZipFileGenerator'
require_relative 'manifest'


class Git
  TEMP_FILE = 'list_of_changes.txt'
  attr_accessor :project_folder, :commit_guid

  def initialize(options={})
    @project_folder    = options[:project_folder]    || ""
    @commit_guid = options[:commit_guid] || ""
  end

  def get_diff(path, commit)

    cmd = 'git diff --name-only ' +commit +' > ' + get_path_temp_file
    Dir.chdir(path){
      system(cmd)
    }
    list_files(path)
  end


  def list_files(path)
    files = []
    temp_path = @project_folder + "/temp/"
    base_path = path
    manifest_path = "#{temp_path}/manifest.php"

    File.open(get_path_temp_file).each do |line|
      cmd = "cd #{base_path} && rsync -R " + line.strip.gsub("sugar/", "") + " " + temp_path
      system(cmd)

      file_path = line.strip.gsub('sugar/', '')
      files << {from: "<basepath>/Files/#{file_path}", to: file_path}
    end

    manifest = Manifest.new
    manifest.generate_file(files, manifest_path)

    zip(@project_folder + "/temp",@project_folder + "/out.zip")

  end

  def zip(directory_to_zip,output_file)
    if File.exist?(output_file)
      File.delete(output_file)
    end
    zf = ZipFileGenerator.new(directory_to_zip, output_file)
    zf.write()
  end

  def get_path_temp_file
    return Dir.pwd + '/' + TEMP_FILE
  end

  def delete_temp_file()
      File.delete(get_path_temp_file)
  end

end


