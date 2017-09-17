class FileHandler
  require 'csv'
  require 'json'

  class << self
    def load_csv(filename, &block)
      CSV.foreach(filename) do |row|
        block.call(row)
      end
    end

    def save_csv(filename, &block)
      CSV.open(filename, 'wb') do |csv|
        block.call(csv)
      end
    end

    def json_file_save(filename, data)
      File.open("#{filename}",'w') do |f|
        f.write(data.to_json)
      end
    end
  end
end