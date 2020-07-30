class AbstractData
  def self.get_data(source)
    raise NotImplementedError,
      "Class has not implemented method '#{__method__}'"
  end

  def self.error_handler(error)
    p error.message
    return nil
  end
end


class JsonData < AbstractData
  def self.get_data(source)
    begin
      require 'json'
      json = File.read(source)
      JSON.parse(json)
    rescue Exception => error
      error_handler(error)
    end
  end
end


class CsvData < AbstractData
  def self.get_data(source)
    begin
      require 'csv'
      table = CSV.parse(File.read(source), headers: true)
      result = {}
      table.each do |i|
        result[i.field('Cur_Abbreviation')] = Hash[
          'Cur_Scale' => i.field('Cur_Scale').to_i,
          'Cur_Name' => i.field('Cur_Name'),
          'Cur_OfficialRate' => i.field('Cur_OfficialRate').to_f,
        ]
      end
      result
    rescue Exception => error
      error_handler(error)
    end
  end
end


class WebData < AbstractData
  extend DataUtils

  def self.get_data(source)
    begin
      result = {}
      get_raw_json(source).each do |i|
        result[ i['Cur_Abbreviation'] ] = {
          'Cur_Scale' => i['Cur_Scale'],
          'Cur_Name' => i['Cur_Name'],
          'Cur_OfficialRate' => i['Cur_OfficialRate'],
        }
      end
      result
    rescue Exception => error
      error_handler(error)
    end
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
      return result
    end
  end
end
