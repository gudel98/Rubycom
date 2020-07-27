class AbstractData
  def self.get_data(source = '')
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end


class JsonData < AbstractData
  def self.get_data(source = '../data.json')
    require 'json'

    json = File.read(source)
    JSON.parse(json)
  end
end


class CsvData < AbstractData
  def self.get_data(source = '../data.csv')
  end
end


class WebData < AbstractData
  def self.get_data(source = 'https://www.nbrb.by/api/exrates/rates?periodicity=0')
    require 'open-uri'
    require 'json'

    json = URI.open(source).read
    result = {}
    JSON.parse(json).each do |i|
      result[ i['Cur_Abbreviation'] ] = {
        'Cur_Scale' => i['Cur_Scale'],
        'Cur_Name' => i['Cur_Name'],
        'Cur_OfficialRate' => i['Cur_OfficialRate'],
      }
    end


    #require 'pry'
    #binding.pry

    require 'json'
    File.open("data.json","w") { |f| f.write(result.to_json) }
=begin
    binding.pry
    require 'csv'
    CSV.open('data.csv', 'wb') {|csv| objs.to_a.each {|elem| csv << elem} }
=end
    result
  end
end


class DataFactory
  def self.for(type)
    Object.const_get(type.capitalize + 'Data')
  end
end


class Converter

  def initialize(data)
    @data = data #DataFactory.for(type).get_data
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
    #I18n.default_locale = :en
    #I18n.locale = :en
    Money.locale_backend = :i18n
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
    #Money.add_rate(cur_from, cur_to, rate)
    "#{ Money.from_amount(amount, cur_from).format } => #{ Money.from_amount(result, cur_to).format }"
  end
end
