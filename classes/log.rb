class Log
  attr_accessor :types

  def initialize()
    # @outputs = outputs
    @types = [:info, :menu, :error]
  end

  def info(output, message)
    if output.to_sym == :screen
      puts "INFO: #{message}"
    end
  end

  def menu(output, message)
    if output.to_sym == :screen
      puts "#{message}"
    end
  end

  def error(output, message)
    if output.to_sym == :screen
      puts "ERROR: #{message}"
    end


  end
end