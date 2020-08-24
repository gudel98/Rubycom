# frozen_string_literal: true

require 'json'
require 'csv'

# It is abstract parent for the concrete class
class AbstractData
  def self.get_data(_)
    raise(NotImplementedError, "Class has not implemented method '#{__method__}'")
  end

  def self.error_handler(error)
    p "Ooo, NO :(  + #{error.class} + ':' + #{error.message}"
    nil
  end
end

# JSON class
class JsonData < AbstractData
  def self.get_data(source)
    json = File.read(source)
    JSON.parse(json.to_s)
  rescue Errno::ENOENT, JSON::ParserError => e
    error_handler(e)
  end
end

# CSV class
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
  rescue Errno::ENOENT, CSV::MalformedCSVError => e
    error_handler(e)
  end
end

# Web API class
class WebData < AbstractData
  def self.get_data(source)
    result = {}
    DataUtils.get_raw_json(source).each do |i|
      result[ i['Cur_Abbreviation'] ] = {
        'Cur_Scale' => i['Cur_Scale'],
        'Cur_Name' => i['Cur_Name'],
        'Cur_OfficialRate' => i['Cur_OfficialRate']
      }
    end
    result
  rescue ArgumentError, SocketError, Errno::ENOENT, JSON::ParserError => e
    error_handler(e)
  end
end

# It provides the suitable class by name
class DataFactory
  def self.for(type)
    raise ArgumentError, "Parameter 'type' must be a string" if type.class != String

    Object.const_get(type.capitalize + 'Data')
  rescue ArgumentError => e
    p e.message
    nil
  rescue NameError
    p "Invalid parameter 'type' value. Available values: 'csv', 'json', 'web'" \
      ' (case insensitive).'
    nil
  end
end
