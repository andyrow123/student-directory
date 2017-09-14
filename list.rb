class List
  @@lists = Array.new

  attr_accessor :id, :title, :width, :data_source, :keys, :data

  def initialize(id, title, width, data_source, keys, data=[])
    @id = id
    @title = title
    @width = width
    @data_source = data_source
    @keys = keys
    @headings = keys.map {|e| e.dup }.unshift('')
    @data = data.empty? ? get_data(@data_source) : data
    @col_widths = @data.empty? ? [] : calculate_col_widths(@data, @headings)
    @format_str = column_format(@col_widths)
    @@lists << self
  end

  def self.all
    @@lists
  end

  def self.load_list(list_id)
    list = @@lists.detect{ |list|
      list.id == list_id
    }
    # list.draw
    loop do
      list.draw
      input = STDIN.gets.chomp
      break if input == 'b'
      list.process(input)
    end
  end

  def process(selection)
    case selection
      when '1'
        # menu_item = menu_items.detect{ |menu_item|
        #   menu_item.key == '1'
        # }
        # eval(menu_item.route)
      else
        puts "I don't know what you meant, try again."
    end
  end

  def self.find(list_id)
    @@lists.detect{ |list|
      list.id == list_id
    }
  end

  def self.draw(list)
    get_data(list.data_source)
    header
    list(list.keys, list.data)
    footer(list.data)
  end

  def draw
    get_data(@data_source)
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

  def footer(objects)
    # finally, we print the total number of students
    divider
    puts "Overall, we have #{objects.count} great #{objects.count < 2 ? 'student' : 'students'}"
    divider
    puts 'Menu - | [b] Back | [number] View Record'
  end


  private

  def get_data(data_source)
    @data = eval(data_source)
    if @data.empty?
      return []
    else
      @col_widths = calculate_col_widths(@data, @headings)
      @format_str = column_format(@col_widths)
    end
    # calculate_col_widths(@data, @headings)
  end

  def calculate_col_widths(data, headings)
    widths = []
    headings.each {|heading|
      if heading.empty?
        widths << 3
      else
        col_values = []
        data.map {|item|
          term = "item.#{heading}.to_s"
          col_values << eval(term)
        }
        widths << col_values.max_by(&:length).length + 6
      end

    }
    @width = widths.inject(:+)
    widths
  end

  def column_format(widths)
    format_str = ''
    widths.each {|width|
      width = width
      format_str = format_str + "%-#{width}s"
    }
    format_str
  end

  def empty_list(filters)

    puts ''
    puts ''
    filters == '' ?
        (puts 'There are no results to display'.center(@width)) :
        (puts "After filtering with: #{filters} - There are no results to display".center(@width))
    puts ''
    puts ''
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
    headings = @headings
    format_str = @format_str

    puts format_str % headings.map{|heading| heading.capitalize}
    divider
    if result.empty?
      empty_list(filters)
    else
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
      result = res
    end
    result
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
