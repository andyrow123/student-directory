require './classes/file_handler'
require './classes/log'

class String
  def is_i?
    /\A[-+]?\d+\z/ === self
  end
end


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

    def load_csv(file_check, filename, &block)
      FileHandler.load_csv(file_check, filename) { |row|
        block.call(row)
      }
    end

    def save_csv(file_check, filename, &block)
      FileHandler.save_csv(file_check, filename) { |csv|
        block.call(csv)
      }
    end
  end
end