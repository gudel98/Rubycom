require 'json'
require 'csv'

class AbstractData
  extend DataUtils
  def self.get_data(source)
    raise NotImplementedError,
      "Class has not implemented method '#{__method__}'"
  end

  def self.error_handler(error)
    p 'Ooo, NO :( ' + error.message
    nil
  end
end

class JsonData < AbstractData
  def self.get_data(source)
    json = File.read(source)
    JSON.parse(json.to_s)
  rescue Errno::ENOENT => error
    error_handler(error)
  rescue JSON::ParserError => error
    error_handler(error)
  end
end

class CsvData < AbstractData
  def self.get_data(source)
    table = CSV.parse(File.read(source).to_s, headers: true)
    result = {}
    table.each do |row|
      result[row['Cur_Abbreviation']] = Hash[
        'Cur_Scale' => row['Cur_Scale'].to_i,
        'Cur_Name' => row['Cur_Name'],
        'Cur_OfficialRate' => row['Cur_OfficialRate'].to_f,
      ]
    end
    result
  rescue Errno::ENOENT => error
    error_handler(error)
  rescue CSV::MalformedCSVError => error
    error_handler(error)
  end
end

class WebData < AbstractData
  def self.get_data(source)
    result = {}
    get_raw_json(source).each do |i|
      result[ i['Cur_Abbreviation'] ] = {
        'Cur_Scale' => i['Cur_Scale'],
        'Cur_Name' => i['Cur_Name'],
        'Cur_OfficialRate' => i['Cur_OfficialRate'],
      }
    end
    result
  rescue Errno::ENOENT => error
    error_handler(error)
  rescue JSON::ParserError => error
    error_handler(error)
  end
end

class DataFactory
  def self.for(type)
    result = nil
    begin
      raise ArgumentError, "Parameter 'type' must be a string" if type.class != String

      result = Object.const_get(type.capitalize + 'Data')

    rescue NameError => error
      p "Invalid parameter 'type' value. Available values: 'csv', 'json', 'web'" \
        " (case insensitive)."
    rescue => error
      p error.message
    ensure
      result
    end
  end
end
