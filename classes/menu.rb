require './classes/base'

class Menu < Base

  @@menus = []

  attr_accessor :id, :title, :width, :type, :menu_items

  def initialize(id, title, width, type = :vertical, menu_items = [])
    @id = id
    @title = title
    @width = width
    @menu_items = menu_items.empty? ? MenuItem.get_by_menu_id(id) : menu_items
    @type = type
    @@menus << self
  end

  # Class methods

  class << self
    def all
      @@menus
    end

    def find(key, value)
      @@menus.detect{ |menu|
        eval("menu.#{key}") == value
      }
    end

    def load_menus(file_check, filename='menus.csv')
      @@menus = []

      self.load_csv(file_check, filename) {|row|
        id, title, width, type = row
        Menu.new(id.to_i, title.to_s, width.to_i, type.to_sym)
      }
      Menu.log(:screen, :info, "Successfully loaded #{@@menus.length} menus from #{filename}.")
    end

    def save_menus(file_check, filename='menus.csv')
      self.load_csv(file_check, filename) {|csv|
        @@menus.each do |menu|
          csv << [menu.id, menu.title, menu.width, menu.type]
        end
      }
      Menu.log(:screen, :info, "Successfully Saved #{filename}")
    end

    def get_menu(menu_id)
      menu = @@menus.detect{ |menu|
        menu.id == menu_id
      }
      loop do
        menu.draw
        menu.process(STDIN.gets.chomp, menu.menu_items)
      end
    end

    def draw(menu)
      # menu.header
      # orientation == :vertical ? menu.vertical_menu(menu.menu_items) : menu.horizontal_menu(menu.title, menu.menu_items)
      # menu. footer(@menu_items)

      if orientation == :vertical
        menu.header
        menu.vertical_menu(menu.menu_items)
        menu.footer(@menu_items)
      else
        menu.horizontal_menu(menu.title, menu.menu_items)
      end
    end
  end

  def get_menu
    menu = self
    loop do
      menu.draw
      process(STDIN.gets.chomp, menu.menu_items)
    end
  end

  def process(selection, menu_items)
    if selection.is_i?
      selection = selection.to_i
    end
    case selection
      when (1..menu_items.length)
        menu_item = menu_items.detect{ |menu_item| menu_item.keypress == selection.to_s }
        eval(menu_item.route)
      when ('a'..'z')
        menu_item = menu_items.detect{ |menu_item| menu_item.keypress == selection }
        menu_item.nil? ? (puts "I don't know what you meant, try again.") : eval(menu_item.route)
      when menu_items.length + 1
        exit # This will cause the program to terminate
      else
        puts "I don't know what you meant, try again."
    end
  end

  def draw
    if self.type == :vertical
      header
      vertical_menu(self.menu_items)
      footer(@menu_items)
    else
      horizontal_menu(self.title,self.menu_items)
    end
  end

  def divider
    puts '-' * @width
  end

  def header
    divider
    puts "#{@title}".center(@width)
    divider
  end

  def vertical_menu(items)
    items.each {|item|
      puts "[#{item.keypress}] #{item.title}"
    }
    # puts "#{items.length + 1}. Exit"
  end

  def horizontal_menu(title, items)
    print "#{title} - "
    items.each {|item|
      print "[#{item.keypress}] #{item.title}   "
    }
    print "\n"
  end

  def footer(objects)
    divider
    puts 'Please select an option: '
    divider
  end
end

class MenuItem < Base
  @@menu_items = Array.new

  attr_accessor :id, :title, :keypress, :menu_id, :route
  def initialize(id, title, keypress, menu_id, route)
    @id = id
    @title = title
    @keypress = keypress
    @menu_id = menu_id
    @route = route
    @@menu_items << self
  end

  class << self

    def find(key, value)
      @@menu_items.select{ |menu|
        eval("menu.#{key}") == value
      }
    end

    def all
      @@menu_items
    end

    def load_menu_items(file_check=false, filename='menu_items.csv')
      @@menu_items = []

      load_csv(file_check, filename) {|row|
        id, title, key, menu_id, route = row
        MenuItem.new(id.to_i,title.to_s, key.to_s, menu_id.to_i, route.to_s)
      }
    end

    def save_menu_items(file_check=true, filename='menu_items.csv')
      save_csv(file_check, filename) {|csv|
        @@menu_items.each do |menu_item|
          csv << [menu_item.title, menu_item.key, menu_item.menu_id, menu_item.route]
        end
      }
    end


    def get_by_menu_id(menu_id)
      MenuItem.find(:menu_id, menu_id)
    end

    def last_id
      (@@menu_items.last).id
    end

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