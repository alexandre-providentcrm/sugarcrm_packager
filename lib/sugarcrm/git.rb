require 'fileutils'
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
    return list_files(path)
  end


  def list_files(path)
    files = []
    temp_path = @project_folder + "/temp/"
    base_path = path

    File.open(get_path_temp_file).each do |line|
      cmd = "cd #{base_path} && rsync -R " + line.strip.gsub("sugar/", "") + " " + temp_path
      system(cmd)

      file_path = line.strip.gsub('sugar/', '')
      files << {from: "<basepath>/#{file_path}", to: file_path}
    end

    #delete_temp_file
    
    return files

  end

  def get_path_temp_file
    return Dir.pwd + '/' + TEMP_FILE
  end

  def delete_temp_file
      File.delete(get_path_temp_file)
  end

end


