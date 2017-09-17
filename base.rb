require './file_handler'
require './log'

class Base
  @@logger = Log.new

  class << self
    def log(output, type, message)
      if !@@logger.types.include?(type)
        @@logger.error(output, "Type - #{type.to_s} - not found.")
      else
        string = "@@logger.#{type.to_s}('#{output}', '#{message.to_s}')"
        eval(string)
      end
    end

    def load_csv(filename, &block)
      FileHandler.load_csv(filename) { |row|
        block.call(row)
      }
    end

    def save_csv(filename, &block)
      FileHandler.save_csv(filename) { |csv|
        block.call(csv)
      }
    end
  end
end