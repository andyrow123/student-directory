class Student
  @@students = Array.new
  attr_accessor :name, :sex, :age, :cohort

  def initialize(name, sex, age, cohort)
    @name = name
    @sex = sex
    @age = age
    @cohort = cohort
    @@students << self
  end

  def self.all
    @@students
  end

  def self.keys
    %w(name sex age cohort)
  end

  # def keys
  #   %w(name sex age cohort)
  # end

  def self.add_students
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
      @@students << Student.new(student.name, student.sex, student.age, student.cohort)
      puts "You have added #{student[:name]} to the list, in the #{student[:cohort]} cohort\n"
      # change_response
      puts "You have added #{@@students.count} student#{'s' if @@students.count > 1}. Type in another name to add or press return to proceed"
      name = STDIN.gets.strip
    end
    @students
  end


  def self.load_students(filename='students.csv')
    file = File.open(filename, 'r')
    file.readlines.each do |line|
      name, sex, age, cohort = line.chomp.split(',')
      Student.new(name.to_s, sex.to_s, age.to_i, cohort.to_sym)
    end
    file.close
  end

  def self.save_students
    # open the file for writing
    file = File.open('students.csv', 'w')
    # iterate of the array of students
    @@students.each do |student|
      student_data = [student.name, student.sex, student.age, student.cohort]
      csv_line = student_data.join(',')
      file.puts csv_line
    end
    file.close
  end

  def question(keys)
    puts "Enter the persons #{keys}"
    STDIN.gets.strip.to_sym
  end

  def as_json(options={})
    {
        name: @name,
        sex: @sex,
        age: @age,
        cohort: @cohort
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end
