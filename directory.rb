# class String
#   def is_i?
#     /\A[-+]?\d+\z/ === self
#   end
# end

require './menu.rb'
require './list.rb'
require './student.rb'

require 'json'

def json_file_save(filename, data)
  File.open("#{filename}",'w') do |f|
    f.write(data.to_json)
  end
end

def try_load_students
  filename = ARGV.first # load the first argument from the command line
  return if filename.nil? # get out of the method if it isn't given
  if File.exists?(filename) # if it exists
    Student.load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else # if it doesn't exist
    puts "Sorry, #{filename} does not exist."
    exit # quit program
  end
end

# hold students in an array
@students = []


@main_menu_items = []
@main_menu_items << MenuItem.new('Input the students', '1', 1,'Student.add_students')
@main_menu_items << MenuItem.new('Show the students', '2', 1, 'List.load_list(1)')
@main_menu_items << MenuItem.new('Save the list to students.csv', '3', 1, 'Student.save_students')
@main_menu_items << MenuItem.new('Load the list from students.csv', '4', 1, 'Student.load_students')
# @menu_items << MenuItem.new('Exit', '9', 1)



def main_app
  student_list = List.new(1,'The Students of Villains Academy', 67, 'Student.all', Student.keys, @students)
  new_menu = Menu.new(1,'Main Menu', 67, @main_menu_items)
  new_menu.load_menu
end

# try_load_students
main_app



# @students << Student.new('Dr. Hannibal Lecter', 'M', 55, :november)
# @students << Student.new('Darth Vader', 'M', 100, :december)
# @students << Student.new('Nurse Ratched', 'F', 36, :november)
# @students << Student.new('Michael Corleone', 'M', 55, :december)
# @students << Student.new('Alex DeLarge', 'M', 70, :november)
# @students << Student.new('The Wicked Witch of the West', 'F', 35, :december)
# @students << Student.new('Terminator', 'M', 120, :november)
# @students << Student.new('Freddy Krueger', 'M', 7, :december)
# @students << Student.new('The Joker', 'M', 20, :november)
# @students << Student.new('Joffery Baratheon', 'M', 16, :december)
# @students << Student.new('Norman Bates', 'M', 60, :november)

# json_file_save('students.json', @students)

# json_file_save('main_menu_items.json', @main_menu_items)
