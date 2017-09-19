require './classes/base'
class Student < Base

  @@students = []
  @@possible_cohorts = [:January, :February, :March,
                       :April, :May, :June, :July, :August, :September,
                       :October, :November, :December]

  attr_accessor :name, :sex, :age, :cohort

  def initialize(name='*empty*', sex='*empty*', age='*empty*', cohort='*empty*')
    @name = name
    @sex = sex
    @age = age
    @cohort = cohort
    @@students << self
  end

  # Class methods

  class << self
    def all
      @@students
    end

    def keys
      %w(name sex age cohort)
    end

    def load_students(file_check=false, filename='students.csv')
      @@students = []
      load_csv(file_check, filename) {|row|
        name, sex, age, cohort = row
        Student.new(name.to_s, sex.to_s, age.to_i, cohort.to_sym)
      }

      Student.log(:screen, :info, "Successfully loaded #{@@students.length} students from #{filename}.")
    end

    def save_students(file_check=true, filename='students.csv')
      save_csv(file_check, filename) {|csv|
        @@students.each do |student|
          csv << [student.name, student.sex, student.age, student.cohort]
        end
      }
      Menu.log(:screen, :info, "Successfully Saved #{filename}")
    end

    def add_students
      student = {}
      keys = self.keys.each{|item| student[item.to_sym] = ''}
      puts 'To finish, just hit return twice'
      student[:name] = question(keys.first)
      until student[:name].empty? do
        # keys.shift
        keys[1..-1].each {|key| student[key.to_sym] = question(key) }
        student.each{|item|
          item[1] << '**Empty**' if item[1].empty?
        }
        commit_student(student)
        student[:name] = STDIN.gets.strip
      end
    end

    def keys
      %w(name sex age cohort)
    end

    def question(key)
      puts "Enter the students #{key}"
      STDIN.gets.strip
    end

    def commit_student(student)
      Student.new(student[:name], student[:sex], student[:age], student[:cohort])
      Student.log( :screen,:info, "You have added #{student[:name]} to the list, in the #{student[:cohort]} cohort\n")
      Student.log(:screen, :info, "You have added #{@@students.count} student#{'s' if @@students.count > 1}. Type in another name to add or press return to proceed")
    end

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
