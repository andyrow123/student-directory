class List

  @@lists = []

  attr_accessor :id, :title, :width, :data_source, :keys, :data, :list_menu

  def initialize(id, title, width, data_source, keys, data=[], list_menu)
    @id = id
    @title = title
    @width = width
    @data_source = data_source
    @keys = keys
    @headings = keys.map {|e| e.dup }.unshift('')
    @data = data.empty? ? get_data(@data_source) : data
    @col_widths = @data.empty? ? [] : calculate_col_widths(@data, @headings)
    @format_str = column_format(@col_widths)
    @list_menu = list_menu
    @@lists << self
  end

  class << self
    def all
      @@lists
    end

    def get_list(list_id)
      list = @@lists.detect{ |list|
        list.id == list_id
      }
      @list_menu = list.list_menu
      # list.draw
      loop do
        list.draw
        @list_menu.display_menu(:horizontal)
        input = STDIN.gets.chomp
        break if input == 'b'
        list.process(input)
      end
    end

    def find(list_id)
      @@lists.detect{ |list|
        list.id == list_id
      }
    end

    def draw(list)
      get_data(list.data_source)
      header
      list(list.keys, list.data)
      footer(list.data)
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

  end

  def get_data(data_source)
    data = eval(data_source)
    if data.empty?
      return []
    else
      @col_widths = calculate_col_widths(data, @headings)
      @format_str = column_format(@col_widths)
    end
    @data = data
    data
    # calculate_col_widths(@data, @headings)
  end


  private


  def calculate_col_widths(data, headings)
    widths = []
    headings.each {|heading|
      if heading.empty?
        widths << 3
      else
        col_values = []
        data.map {|item|
          col_values << eval("item.#{heading}.to_s")
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

  def list(keys, data, filters='', group_by='name')
    # if !filters.empty?
    # filters the data using specified filters
    result = list_filter(data, filters)
    # applies formatting to the column headings and puts to screen
    puts @format_str % @headings.map{|heading| heading.capitalize}
    divider
    # checks if the filters have returned an empty result and if so puts message to screen
    if result.empty?
      empty_list(filters)
    else
      # Group the results by Cohort and write to screen
      group_list_entries(result, group_by)
    end
    keys.reject! {|item| item.empty?}
  end

  def sort_list_entries(data, sort_by)
    data.sort_by { |item|
      eval("item.#{sort_by}")
    }
  end

  def group_list_entries(data, group_by)
    grouped_results = {}

    # order and group alphabetically
    data.sort_by { |item|
      eval("item.#{group_by}")
    }.group_by{|item|
      eval("item.#{group_by}[0]")
      # filter[0]
    }.map {|grouped_by, array| grouped_results[grouped_by] = array }

    # group by key
    # data.group_by { |lst_obj| eval("lst_obj.#{group_by}") }.map {|grouped_by, array| grouped_results[grouped_by] = array }
    # List selection counter
    c = 1
    # print each group heading and result array to screen
    grouped_results.each {|grouped_result|
      # puts the heading to screen
      puts "-#{grouped_result[0].to_s.capitalize}-".center(@width)
      # goes through each headings grouped results
      grouped_result[1].each do |result|
        str_arr = [c]
        # adds each result entry to the string array
        keys.each{|key| str_arr <<  eval("result.#{key}") }
        # applies formatting and puts result to screen
        puts @format_str % str_arr
        c += 1
      end
    }
    grouped_results
  end

  def list_filter(data, filters)
    # downcase the filters and insert into an array
    search_filters = filters.downcase.split(',')
    filter_count = 0
    # if the array of filters has an empty filter delete it
    search_filters.reject! { |item| item.empty? }
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
