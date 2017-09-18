class FileHandler
  require 'csv'
  require 'json'

  $CSV_PATH = 'csv/'
  $JSON_PATH = 'json/'

  class << self

    def exist?(path)
      File.exist?(path)
    end

    def file_name(filename)
      puts "Filename: [#{filename}]"
      answer = STDIN.gets.strip
      return filename if answer.empty?
      answer
    end

    def file_replace(filename)
      puts "#{filename} already exists. Do you want to overwrite: [Y/N]"
      STDIN.gets.strip.downcase == 'y' ? true : filename = file_name(filename)
      filename
    end

    def load_csv(file_check, filename, &block)
      if file_check
       filename = file_name(filename) if exist?("#{$CSV_PATH + filename}")
      end
      CSV.foreach("#{$CSV_PATH + filename}") do |row|
        block.call(row)
      end
    end

    def save_csv(file_check, filename, &block)
      if file_check
        if exist?("#{$CSV_PATH + filename}")
          filename = file_replace(filename)
        else
          filename = file_name(filename)
        end
      end
      CSV.open("#{$CSV_PATH + filename}", 'wb') do |csv|
        block.call(csv)
      end
    end

    def json_file_save(filename, data)
      File.open("#{$JSON_PATH + filename}",'w') do |f|
        f.write(data.to_json)
      end
    end
  end
end