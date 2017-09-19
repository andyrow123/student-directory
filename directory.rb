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
  # main_menu = Menu.find(:id, 1)
  list_menu = Menu.find(:id, 2)

  # create student list object
  student_list = List.new(1,'The Students of Villains Academy', 89, 'Student.all', Student.keys, [], list_menu)
  student_keys = student_list.keys

  # create sort menu
  sort_menu = Menu.find(:id, 4)
  last_id = MenuItem.last_id
  route_str = "List.get_list(1)"
  student_keys.each_with_index {|key, index|
    sort_menu.menu_items <<
        MenuItem.new(last_id + 1, key.capitalize, (index + 1).to_s, sort_menu.id, "List.get_list(1,'', 'sort', '#{key}')" )
    last_id += 1
  }
  sort_menu.menu_items << MenuItem.new(last_id, 'Back', (student_keys.length + 1).to_s, sort_menu.id, "Menu.get_menu(2)" )

  # create group menu
  group_menu = Menu.find(:id, 5)
  last_id = MenuItem.last_id
  route_str = "List.get_list(1)"
  student_keys.each_with_index {|key, index|
    group_menu.menu_items <<
        MenuItem.new(last_id + 1, key.capitalize, (index + 1).to_s, group_menu.id, "List.get_list(1,'', 'group', '#{key}')" )
    last_id += 1
  }
  group_menu.menu_items << MenuItem.new(last_id, 'Back', (student_keys.length + 1).to_s, sort_menu.id, "Menu.get_menu(2)" )

  source_menu.get_menu
  # # display main menu
  # main_menu.get_menu(:vertical)

end

try_load_students
main_app
