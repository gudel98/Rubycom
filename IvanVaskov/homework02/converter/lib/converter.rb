require_relative "./data_utils"
require_relative "./data_provider"

require 'money'
require 'i18n'

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
    rescue Exception => error
      p error.message
    end
  end
end
