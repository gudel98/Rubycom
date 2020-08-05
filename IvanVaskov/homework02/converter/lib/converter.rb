# frozen_string_literal: true

require_relative "./data_utils"
require_relative "./data_provider"

require 'money'
require 'i18n'

class Converter

  def initialize(data)
    if data == nil
      raise ArgumentError.new("'data' can't be nil")
    end
    @data = data
    Money.locale_backend = nil
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
  end

  def convert_validator?(amount, currency_from, currency_to)
    conditions = [
      [(amount.is_a?Integer), "'amount' must be an 'Integer' type"],
      [amount > 0, "'amount' must be greater than zero"],
      [(currency_from.is_a?String) && (currency_to.is_a?String),
      "Currency abbreviation must be a 'String' type"],
      [(currency_from.length == 3) && (currency_to.length == 3),
      "Currency abbreviation length must be equals 3"],
      [(currency_from.upcase == 'BYN') || @data.has_key?(currency_from.upcase),
      "Currency '#{currency_from.upcase}' not found"],
      [(currency_to.upcase == 'BYN') || @data.has_key?(currency_to.upcase),
      "Currency '#{currency_to.upcase}' not found"],
    ]
    check_conditions?(conditions)
  end

  def convert(amount, currency_from, currency_to)
    unless convert_validator?(amount, currency_from, currency_to)
      method(__method__).parameters.each do |arg|
        print "#{arg[1]}=#{eval(arg[1].to_s)}; "
      end
      return
    end
    begin
      cur_from = currency_from.upcase
      cur_to = currency_to.upcase
      params_from = get_currency_params(cur_from)
      params_to = get_currency_params(cur_to)
      result = amount * (params_from[:rate] * params_to[:scale]) /
        (params_to[:rate] * params_from[:scale])
      money_from = Money.new(amount, cur_from)
      money_to = Money.new(result, cur_to)
      p format_convert(money_from, money_to)
      [money_from, money_to]
    rescue StandardError => error
      p error.message
    end
  end

  private

  def format_convert(money_from, money_to)
    "#{ money_from.format } => #{ money_to.format } :" \
      "(#{money_from.currency.name} => #{money_to.currency.name})"
  end

  def check_conditions?(conditions)
    result = []
    conditions.each {|cnd| result << cnd[1] unless cnd[0] }
    puts result.join("\n")
    errors = result
    result.size == 0
  end

  def get_currency_params(currency)
    if currency == 'BYN'
      rate = 1
      scale = 1
    else
      rate = @data[currency]['Cur_OfficialRate']
      scale = @data[currency]['Cur_Scale']
    end
    {rate: rate, scale: scale}
  end

end