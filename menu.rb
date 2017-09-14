class Menu
  @@menus = Array.new

  attr_accessor :id, :title, :width, :menu_items

  def initialize(id, title, width, menu_items=[])
    @id = id
    @title = title
    @width = width
    @menu_items = menu_items
    @@menus << self
  end

  def self.all
    @@menus
  end

  def self.find(menu_id)
    @@menus.detect{ |menu|
      menu.id == menu_id
    }
  end

  def self.load_menu(menu_id)
    menu = @@menus.detect{ |menu|
      menu.id == menu_id
    }
    loop do
      draw(menu)
      process(STDIN.gets.chomp, menu.menu_items)
    end
  end

  def load_menu
    menu = self
    loop do
      draw(menu)
      process(STDIN.gets.chomp, menu.menu_items)
    end
  end

  def process(selection, menu_items)
    case selection
      when '1'
        menu_item = menu_items.detect{ |menu_item|
          menu_item.key == '1'
        }
        eval(menu_item.route)
        # input_students
      when '2'
        menu_item = menu_items.detect{ |menu_item|
          menu_item.key == '2'
        }
        eval(menu_item.route)
        # show_students
      when '3'
        menu_item = menu_items.detect{ |menu_item|
          menu_item.key == '3'
        }
        eval(menu_item.route)
        # save_students
      when '4'
        menu_item = menu_items.detect{ |menu_item|
          menu_item.key == '4'
        }
        eval(menu_item.route)
        # load_students
      when '5'
        exit # This will cause the program to terminate
      else
        puts "I don't know what you meant, try again."
    end
  end

  def draw(menu)
    header
    menu(menu.menu_items)
    footer(@menu_items)
  end

  def divider
    puts '-' * @width
  end

  def header
    divider
    puts "#{@title} - #{@id}".center(@width)
    divider
  end

  def menu(items)
    items.each {|item|
      puts "#{item.key}. #{item.title}"
    }
    puts "#{items.length + 1}. Exit"
  end

  def footer(objects)
    divider
    puts 'Please select an option: '
    divider
  end
end

class MenuItem
  @@menu_items = Array.new

  attr_accessor :title, :key, :menu_id, :route
  def initialize(title, key, menu_id, route)
    @title = title
    @key = key
    @menu_id = menu_id
    @route = route
    @@menu_items << self
  end

  def self.all
    @@menu_items
  end

  def self.find_by_key(key)
    @@menu_items.detect{ |menu_item|
      menu_item.key == key
    }
  end

  def as_json(options={})
    {
        title: @title,
        key: @key,
        menu_id: @menu_id,
        route: @route
    }
  end

  def to_json(*options)
    as_json(*options).to_json(*options)
  end

end