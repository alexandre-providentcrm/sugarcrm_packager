require_relative 'sugarcrm/manifest'
require 'readline'

class Sugarcrm

  @@valid_actions = ['create', 'quit']

  def initialize()
  end

  def launch!
    output_introduction
    # action loop
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
    end
    output_conclusion
  end


  private

  def get_action
    action = nil
    # Keep asking for user input until we get a valid action
    until @@valid_actions.include?(action)
      puts "Action not recognized." if action
      output_valid_actions
      user_response = user_input('> ')
      args = user_response.downcase.split(' ')
      action = args.shift
    end
    return action, args
  end

  def do_action(action, args=[])
    case action
    when 'list'
      when 'create'
        create
      when 'quit'
        return :quit
    end
  end
  def create
    output_action_header("Create a new Package")
    attributes = package_attribute_input

    manifest = Manifest.new(attributes)

    if manifest.create_file
      puts "\nPackage Created\n\n"
    else
      puts "\nSave Error: Package not created\n\n"
    end
  end

  def output_introduction
    puts "\n\n<<< Welcome to SugarCrm Package Creator >>>\n\n"
    puts "This is an interactive guide to help you create packages to SugarCRM Cloud.\n\n"
  end

  def output_conclusion
    puts "\n<<< Goodbye! >>>\n\n\n"
  end

  def output_valid_actions
    puts "Actions: " + @@valid_actions.join(", ")
  end

  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end
  def package_attribute_input
    args = {}
    print "Project Folder:"
    args[:project_folder] = user_input('')

    print "Last commit GUID: "
    args[:commit_guid] = user_input('')

    print "Package Name: "
    args[:name] = user_input('')

    print "Package Description: "
    args[:description] = user_input('')

    print "Package Published Date: "
    args[:published_date] = user_input('')

    print "Package version: "
    args[:version] = user_input('')

    return args
  end

  def user_input(prompt=nil)
    prompt ||= '> '
    result = Readline.readline(prompt, true)
    result.strip
  end

end