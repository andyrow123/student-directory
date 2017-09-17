require './base'

class Menu < Base

  @@menus = []

  attr_accessor :id, :title, :width, :menu_items, :type

  def initialize(id, title, width, menu_items = [], type = :vertical)
    @id = id
    @title = title
    @width = width
    @menu_items = MenuItem.get_by_menu_id(id)
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

    def load_menus(filename='menus.csv')
      @@menus = []

      self.load_csv(filename) {|row|
        id, title, width = row
        Menu.new(id.to_i, title.to_s, width.to_i)
      }
      Menu.log(:screen, :info, "Successfully loaded #{@@menus.length} menus from #{filename}.")

    end

    def save_menus(filename='menus.csv')
      self.load_csv(filename) {|csv|
        @@menus.each do |menu|
          csv << [menu.id, menu.title, menu.width]
        end
      }
      Menu.log(:screen, :info, "Successfully Saved #{filename}")
    end

    def display_menu
      menu = self
      loop do
        draw(menu, menu.type)
        process(STDIN.gets.chomp, menu.menu_items)
      end
    end

    def draw(orientation)
      header
      orientation == :vertical ? vertical_menu(self.menu_items) : horizontal_menu(self.menu_items)
      footer(@menu_items)
    end
  end

  def display_menu(orientation)
    menu = self
    loop do
      menu.draw(orientation)
      process(STDIN.gets.chomp, menu.menu_items)
    end
  end

  def process(selection, menu_items)
    case selection.to_i
      when (1..menu_items.length)
        menu_item = menu_items.detect{ |menu_item|
          menu_item.keypress == selection
        }

        Menu.log(:screen, :info, "Successfully loaded #{menu_item.title}")
        eval(menu_item.route)
      when menu_items.length + 1
        exit # This will cause the program to terminate
      else
        puts "I don't know what you meant, try again."
    end
  end

  def draw(orientation)
    if orientation == :vertical
      header
      vertical_menu(self.menu_items)
      footer(@menu_items)
    else
      horizontal_menu(self.menu_items)
    end
  end

  def divider
    puts '-' * @width
  end

  def header
    divider
    puts "#{@title} - #{@id}".center(@width)
    divider
  end

  def vertical_menu(items)
    items.each {|item|
      puts "#{item.keypress}. #{item.title}"
    }
    # puts "#{items.length + 1}. Exit"
  end

  def horizontal_menu(items)
    items.each {|item|
      print "  [#{item.keypress}] #{item.title}  "
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

  attr_accessor :title, :keypress, :menu_id, :route
  def initialize(title, keypress, menu_id, route)
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

    # def find_by_keypress(keypress)
    #   @@menu_items.detect{ |menu_item|
    #     menu_item.key == keypress
    #   }
    # end

    def load_menu_items(filename='menu_items.csv')
      @@menu_items = []

      self.load_csv(filename) {|row|
        title, key, menu_id, route = row
        MenuItem.new(title.to_s, key.to_s, menu_id.to_i, route.to_s)
      }

      # FileUtils.load_csv(filename) { |row|
      #   id, title, width = row
      #   Menu.new(id.to_i, title.to_s, width.to_i)
      # }
      # CSV.foreach(filename) do |row|
      #   id, title, width = row
      #   Menu.new(id.to_i, title.to_s, width.to_i)
      # end
    end

    def save_menu_items(filename='menu_items.csv')
      self.save_csv(filename) {|csv|
        @@menu_items.each do |menu_item|
          csv << [menu_item.title, menu_item.key, menu_item.menu_id, menu_item.route]
        end
      }

      # FileUtils.save_csv(filename) { |csv|
      #   @@menus.each do |menu|
      #     csv << [menu.id, menu.title, menu.width]
      #   end
      # }
      # CSV.open(filename, 'wb') do |csv|
      #   @@menus.each do |menu|
      #     csv << [menu.id, menu.title, menu.width]
      #   end
      #
      # end
    end


    def get_by_menu_id(menu_id)
      MenuItem.find(:menu_id, menu_id)
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