module DataUtils
  require 'open-uri'
  require 'json'
  require 'csv'

  def get_raw_json(source =
    'https://www.nbrb.by/api/exrates/rates?periodicity=0')

    json = URI.open(source).read
    JSON.parse(json)
  end


  def hash_to_json_file(hash, path)
    File.open("#{path}/data.json","w") { |f| f.write(hash.to_json) }
  end


  def raw_json_to_csv_file(raw_json, path)
    CSV.open("#{path}/data.csv", 'wb') do |csv|
      csv << ['Cur_Abbreviation', 'Cur_Scale', 'Cur_Name', 'Cur_OfficialRate']
      raw_json.each do |elem|
        csv << [
          elem['Cur_Abbreviation'],
          elem['Cur_Scale'],
          elem['Cur_Name'],
          elem['Cur_OfficialRate']]
      end
    end
  end
end

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

  def self.get_data(source =
      'https://www.nbrb.by/api/exrates/rates?periodicity=0')
    begin
      #p caller[0][/[^:]+/]
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


class Converter

  def initialize(data)
    @data = data
  end


  def convert_validator?(amount, currency_from, currency_to)
    result = false

    unless amount.is_a?Integer
      p "'amount' must be an 'Integer' type"
      return result
    end

    unless amount > 0
      p "'amount' must be greater than zero"
      return result
    end

    unless (currency_from.is_a?String) && (currency_to.is_a?String)
      p "Currency abbreviation must be a 'String' type"
      return result
    end

    unless (currency_from.length == 3) && (currency_to.length == 3)
      p "Currency abbreviation length must be equals 3"
      return result
    end

    unless (currency_from.upcase == 'BYN') || @data.has_key?(currency_from.upcase)
      p "Currency '#{currency_from.upcase}' not found"
      return result
    end

    unless (currency_to.upcase == 'BYN') || @data.has_key?(currency_to.upcase)
      p "Currency '#{currency_to.upcase}' not found"
      return result
    end
    result = true
  end


  def convert(amount, currency_from, currency_to)
    require 'money'
    require 'i18n'

    return unless convert_validator?(amount, currency_from, currency_to)
    begin
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

      "#{ Money.new(amount, cur_from).format } => #{ Money.new(result, cur_to).format }"
      #"#{ Money.from_amount(amount, cur_from).format } => " \
      #  "#{ Money.from_amount(result, cur_to).format }"
    rescue Exception => error
      p error.message
    end
  end
end
