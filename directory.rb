class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end

@students = []

def save_students
  # open the file for writing
  file = File.open('students.csv', 'w')
  # iterate of the array of students
  @students. each do |student|
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
    when '9'
      exit # This will cause the program to terminate
    else
      puts "I don't know what you meant, try again."
  end
end

def interactive_menu

  loop do
    print_menu
    process(gets.chomp)
  end
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
      student[key] = 'missing' if student[key] == :''
    end
    @students << student
    puts "You have added #{student[:name]} to the list, in the #{student[:cohort]} cohort\n"
    # change_response
    puts "You have added #{@students.count} student#{'s' if @students.count > 1}. Type in another name to add or press return to proceed"
    name = STDIN.gets.strip
  end
  @students
end

def question(keys)
  puts "Enter the persons #{keys}"
  STDIN.gets.strip.to_sym
end

# # # first we put all student into an array
# students = [
#     {name: 'Dr. Hannibal Lecter', sex: 'M', age: 37, cohort: :november},
#     {name: 'Darth Vader', sex: 'M', age: 100,  cohort: :december},
#     {name: 'Nurse Ratched', sex: 'F', age: 36,  cohort: :november},
#     {name: 'Michael Corleone', sex: 'M', age: 55,  cohort: :november},
#     {name: 'Alex DeLarge', sex: 'M', age: 70,  cohort: :november},
#     {name: 'The Wicked Witch of the West', sex: 'F', age: 35,  cohort: :december},
#     {name: 'Terminator', sex: 'M', age: 120,  cohort: :december},
#     {name: 'Freddy Krueger', sex: 'M', age: 7,  cohort: :december},
#     {name: 'The Joker', sex: 'M', age: 20,  cohort: :december},
#     {name: 'Joffery Baratheon', sex: 'M', age: 16,  cohort: :december},
#     {name: 'Norman Bates', sex: 'M', age: 50,  cohort: :december},
# ]

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


interactive_menu

# students = input_students
# print_header
# print_list(%w(name sex age cohort), students)
# print_footer(students)
