require './menu.rb'
require './list.rb'
require './student.rb'

def try_load_students
  filename = ARGV.first # load the first argument from the command line
  return Student.log(:screen, :error, 'Command-line filename is nil. Load manually') if filename.nil? # get out of the method if it isn't given
  if File.exists?(filename) # if it exists
    Student.load_students(filename)
    Student.log(:screen, :info, "Successfully loaded #{Student.all.length} students from #{filename}.")
  else # if it doesn't exist
    Student.log(:screen, :error, "Sorry #{filename} does not exist.")
    exit # quit program
  end
end

def main_app
  # load menus
  MenuItem.load_menu_items
  Menu.load_menus

  list_menu = Menu.find(:id, 2)

  # create list object
  student_list = List.new(1,'The Students of Villains Academy', 80, 'Student.all', Student.keys, [], list_menu)

  # find main menu
  main_menu = Menu.find(:id, 1)
  # display main menu
  main_menu.display_menu(:vertical)

end

try_load_students
main_app
