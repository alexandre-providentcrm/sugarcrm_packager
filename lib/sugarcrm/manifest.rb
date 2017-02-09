require_relative('git')

class Manifest

  attr_accessor :project_folder, :commit_guid, :name,:description,:published_date,:version

  def initialize(options={})
    @project_folder    = options[:project_folder]    || ""
    @commit_guid = options[:commit_guid] || ""
    @name = options[:name] || ""
    @description = options[:description] || ""
    @published_date = options[:published_date] || ""
    @version = options[:version] || ""

  end

  def create_file

    args = { project_folder: Dir.pwd}
    git = Git.new(args)
    git.get_diff(@project_folder,@commit_guid)
    return true
  end

  def generate_file(list_of_files, save_at)
    manifest = " #{create_header} #{create_files_list(list_of_files)} "

    out_file = File.new(save_at, "w")

    out_file.puts(manifest)

    out_file.close

  end
  def create_header
    return "
      <?php
        $manifest = array(
        'acceptable_sugar_flavors' => array('CE','PRO','CORP','ENT','ULT'),
        'acceptable_sugar_versions' => array(
            'exact_matches' => array(),
            'regex_matches' => array('7\\.[0-9]\\.[0-9]$'),
        ),
        'author' => 'SugarCRM',
        'description' => '#{@description}',
        'icon' => '',
        'is_uninstallable' => true,
        'name' => '#{@name}',
        'published_date' => '#{@published_date}',
        'type' => 'module',
        'version' => '#{@version}',
    );"

    end
  def create_files_list(list)
    installdefs = "$installdefs = array(
        'id' => 'package_#{@version}',
        'copy' => array("
    list.each_with_index do |file, index|
      installdefs <<

            "#{index} => array(
                'from' => '#{file[:from]}',
                'to' => '#{file[:to]}',
            ),"
    end
    installdefs << "),); ?>"
    return installdefs
  end

  def valid?
    return false if commit_guid.nil? || commit_guid.blank?
    return false if commit_guid.nil? || commit_guid.blank?
    return true
  end

end