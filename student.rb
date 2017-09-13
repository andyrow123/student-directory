class Student
  @@array = Array.new
  attr_accessor :name, :sex, :age, :cohort

  def self.all
    @@array
  end

  def self.find(param)
    all.detect { |l| l.to_param == param } || raise(ActiveRecord::RecordNotFound)
  end

  def initialize(name, sex, age, cohort)
    @name = name
    @sex = sex
    @age = age
    @cohort = cohort
  end

  def self.keys
    %w(name sex age cohort)
  end

end
