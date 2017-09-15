# class String
#   def is_i?
#     /\A[-+]?\d+\z/ === self
#   end
# end

@students = []

def try_load_students
  filename = ARGV.first # load the first argument from the command line
  return if filename.nil? # get out of the method if it isn't given
  if File.exists?(filename) # if it exists
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else # if it doesn't exist
    puts "Sorry, #{filename} does not exist."
    exit # quit program
  end
end

def add_students(arr, obj)
  arr << object
end

def input_students
  #students = []
  puts 'Please enter the names of the students'
  puts 'To finish, just hit return twice'
  name = STDIN.gets.strip
  keys = [:cohort, :sex, :age]
  until name.empty? do
    student = Hash.new { |this_hash, key| this_hash[key] = 'missing'}
    student[:name] = name
    keys.each do |key|
      student[key] = question(key)
      # student[key] = 'missing' if student[key] == :''
    end
    @students << student
    puts "You have added #{student[:name]} to the list, in the #{student[:cohort]} cohort\n"
    # change_response
    puts "You have added #{@students.count} student#{'s' if @students.count > 1}. Type in another name to add or press return to proceed"
    name = STDIN.gets.strip
  end
  @students
end

def load_students(filename='students.csv')
  file = File.open(filename, 'r')
  file.readlines.each do |line|
    name, sex, age, cohort = line.chomp.split(',')
    @students << {name: name, sex: sex, age: age, cohort: cohort.to_sym}
  end
  file.close
end

def save_students
  # open the file for writing
  file = File.open('students.csv', 'w')
  # iterate of the array of students
  @students.each do |student|
    student_data = [student[:name], student[:sex], student[:age], student[:cohort]]
    csv_line = student_data.join(',')
    file.puts csv_line
  end
  file.close
end

def print_menu
  # 1. print the menu and ask the user what to do
  puts '1. Input the students'
  puts '2. Show the students'
  puts '3. Save the list to students.csv'
  puts '4. Load the list from students.csv'
  puts '9. Exit'
end

def show_students
  print_header
  print_students_list(%w(name sex age cohort))
  print_footer(@students)
end

def process(selection)
  case selection
    when '1'
      input_students
    when '2'
      show_students
    when '3'
      save_students
    when '4'
      load_students
    when '9'
      exit # This will cause the program to terminate
    else
      puts "I don't know what you meant, try again."
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def question(keys)
  puts "Enter the persons #{keys}"
  answer = STDIN.gets.strip.to_sym
  '*Empty*' if answer == ''
end

def divider(width)
  puts '-' * width
end

def print_header
  puts 'The Students of Villains Academy'.center(67)
  divider(67)
end

def filter(array, filter)
  result = []

  if filter == 'all' || filter == ''
    # get all students
    array.each do |student|
      result << student
    end
    # if 's_12' is received it returns names shorter than 12 characters
  elsif filter.start_with?('s_')
    char_count = filter.split('_')[-1].to_i

    # get all students names shorter than 12
    array.select do |student|
      name = student[:name]
      result << student if name.length <= char_count
    end
  else
    # get all students who's name begins with
    array.select do |student|
      letter_array = student[:name].split('')
      result << student if letter_array[0].downcase == filter
    end
  end

  result
end

def print_students_list(keys, filters='')
  puts filters
  search_filters = filters.downcase.split(',')
  filter_count = 0
  search_filters.reject! {|item| item.empty?}
  result = @students
  if !search_filters.to_a.empty?
    res = []
    search_filters.each {|filter|
      if filter_count == 0
        res = filter(result, filter)
        filter_count += 1
      else
        res = filter(res[0], filter)
        filter_count += 1
      end
    }
    result = res
  end

  headings = keys.unshift('')
  format = '%-5s %-40s %-5s %-5s %-5s'
  puts format % headings.map{|heading| heading.capitalize}
  divider(67)
  if result != []
    grouped_results = {}
    result.group_by {|hash|
      hash[:cohort]
    }.map {|v1, v2|
      grouped_results[v1] = v2
    }

    grouped_results.each {|grouped_result|
      puts "*#{grouped_result[0].capitalize}"
      grouped_result[1].each_with_index do |object, index|
        puts format % [index + 1, object[:name], object[:sex], object[:age], object[:cohort]]
      end
    }
  else
    puts ''
    puts ''
    puts "After filtering with: #{search_filters} - There are no results to display!"
    puts ''
    puts ''
  end

end

def print_footer(names)
  # finally, we print the total number of students
  divider(67)
  puts "Overall, we have #{names.count} great #{names.count < 2 ? 'student' : 'students'}"
  divider(67)
end


try_load_students
interactive_menu
