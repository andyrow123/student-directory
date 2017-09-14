class List
  @@lists = Array.new

  attr_accessor :id, :title, :width, :data_source, :keys, :data

  def initialize(id, title, width, data_source, keys, data)
    @id = id
    @title = title
    @width = width
    @data_source = data_source
    @keys = keys
    @data = data.empty? ? eval(data_source) : data
    @format_str = col_format(keys)
    @headings = keys.unshift('')
    @@lists << self
  end

  def self.all
    @@lists
  end

  def self.load_list(list_id)
    list = @@lists.detect{ |list|
      list.id == list_id
    }
    list.draw(list)
    # loop do
    #   list.draw
    #   list.process(STDIN.gets.chomp)
    # end
  end

  def self.find(list_id)
    @@lists.detect{ |list|
      list.id == list_id
    }
  end


  def refresh_data(data_source)
    @data = eval(data_source)
  end

  def draw(list)
    refresh_data(@data_source)
    header
    list(@keys, @data)
    footer(@data)
  end

  def divider
    puts '-' * @width
  end

  def header
    divider
    puts @title.center(@width)
    divider
  end

  def col_format(keys)
    format_str = ''
    headings = keys.unshift('')
    headings.each {|heading|
      width = heading.length + 4
      format_str + "%-#{width}s"
    }
    format_str
  end

  def list(keys, data, filters='')
    result = list_filter(data, filters)
    # search_filters = filters.downcase.split(',')
    # filter_count = 0
    # search_filters.reject! {|item| item.empty?}
    # result = data
    # if !search_filters.to_a.empty?
    #   res = []
    #   search_filters.each {|filter|
    #     if filter_count == 0
    #       res = filter(result, filter)
    #       filter_count += 1
    #     else
    #       res = filter(res[0], filter)
    #       filter_count += 1
    #     end
    #   }
    #   result = res
    # end
    # Adds a blank at the beginning for option number
    headings = keys.unshift('')
    format_str = @format_str
    # headings.each {|heading|
    #   width = heading.length + 4
    #   format_str + "%-#{width}s"
    # }
    # format = '%-5s %-40s %-5s %-5s %-5s'
    puts format_str % headings.map{|heading| heading.capitalize}
    divider
    if result != []
      grouped_results = {}
      result.group_by {|lst_obj|
        lst_obj.cohort
      }.map {|v1, v2|
        grouped_results[v1] = v2
      }

      c = 1

      grouped_results.each {|grouped_result|
        puts "*#{grouped_result[0].capitalize}".center(@width)
        grouped_result[1].each_with_index do |object, index|
          puts format_str % [c, object.name, object.sex, object.age, object.cohort]
          c += 1
        end
      }
    else
      puts ''
      puts ''
      puts "After filtering with: #{search_filters} - There are no results to display!"
      puts ''
      puts ''
    end
    keys.reject! {|item| item.empty?}
  end

  def list_filter(data, filters)
    search_filters = filters.downcase.split(',')
    filter_count = 0
    search_filters.reject! {|item| item.empty?}
    result = data
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
      return res
    end
  end

  def footer(objects)
    # finally, we print the total number of students
    divider
    puts "Overall, we have #{objects.count} great #{objects.count < 2 ? 'student' : 'students'}"
    divider
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

end
