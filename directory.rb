# puts File.read($0)

require './classes/menu.rb'
require './classes/list.rb'
require './classes/student.rb'

def try_load_students
  filename = ARGV.first # load the first argument from the command line
  return Student.log(:screen, :info, 'Command-line filename is nil. Load file manually') if filename.nil? # get out of the method if it isn't given
  if File.exists?("csv/#{filename}") # if it exists
    Student.load_students( false, filename)
  else # if it doesn't exist
    Student.log(:screen, :error, "Sorry #{filename} does not exist.")
    exit # quit program
  end
end

def main_app
  # load menus
  MenuItem.load_menu_items(false)
  Menu.load_menus(false)

  source_menu = Menu.find(:id, 3)
  main_menu = Menu.find(:id, 1)
  list_menu = Menu.find(:id, 2)

  # create student list object
  List.new(1,'The Students of Villains Academy', 84, 'Student.all', Student.keys, [], list_menu)

  source_menu.get_menu(:vertical)
  # # display main menu
  # main_menu.get_menu(:vertical)

end

try_load_students
main_app
