class AbstractData
  def self.get_data(source = '')
    raise NotImplementedError,
      "Class has not implemented method '#{__method__}'"
  end

  def self.error_handler(error)
    p error.message
    return nil
  end
end


class JsonData < AbstractData
  def self.get_data(source = File.dirname(__FILE__) + '/data.json')
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
  def self.get_data(source = File.dirname(__FILE__) + "/data.csv")
    begin
      require 'csv'
      table = CSV.parse(File.read(source), headers: false)
      result = {}
      table.each do |i|
        result[i[0]] = Hash[
          'Cur_Scale' => i[1],
          'Cur_Name' => i[2],
          'Cur_OfficialRate' => i[3],
        ]
      end
      result
    rescue Exception => error
      error_handler(error)
    end
  end
end


class WebData < AbstractData
  def self.get_data(source =
      'https://www.nbrb.by/api/exrates/rates?periodicity=0')
    begin
      require_relative 'data_utils'
      include DataUtils

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
      p "Invalid parameter 'type' value. Available values: 'csv', 'json', 'web'."
    rescue => error
      p error.message
    ensure
      return result
    end
  end
end


class Converter

  def initialize(data)
    @data = data
  end

  def convert(amount, currency_from, currency_to)
    require 'money'
    require 'i18n'

    cur_from = currency_from.upcase
    cur_to = currency_to.upcase

    if cur_from == 'BYN'
      rate_from = 1
      scale_from = 1
    else
      rate_from = @data[cur_from]['Cur_OfficialRate']
      scale_from = @data[cur_from]['Cur_Scale']
    end

    if cur_to == 'BYN'
      rate_to = 1
      scale_to = 1
    else
      rate_to = @data[cur_to]['Cur_OfficialRate']
      scale_to = @data[cur_to]['Cur_Scale']
    end

    result = amount * (rate_from * scale_to) / (rate_to * scale_from)
    I18n.config.available_locales = :en
    Money.locale_backend = :i18n
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP

    "#{ Money.from_amount(amount, cur_from).format } => " \
      "#{ Money.from_amount(result, cur_to).format }"
  end
end
