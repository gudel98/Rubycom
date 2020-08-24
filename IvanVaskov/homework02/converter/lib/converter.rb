# frozen_string_literal: true

require_relative './data_utils'
require_relative './data_provider'

require 'money'
require 'i18n'
require 'pry'

# This is currency converter
class Converter
  attr_reader :data

  def initialize(data)
    raise(ArgumentError, "'data' can't be nil") if data.nil?

    @data = data
    Money.locale_backend = nil
    Money.rounding_mode = BigDecimal::ROUND_HALF_UP
  end

  def convert(amount, currency_from, currency_to)
    args = method(__method__).parameters.map do |arg|
      [arg[1], binding.local_variable_get(arg[1].to_s)]
    end

    return nil unless validate?(args.to_h)

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
  rescue StandardError => e
    p e.message
  end

  private

  def validate?(args)
    violations = get_violations(args)
    if violations.size.positive?
      puts args
      puts violations.join("\n") + "\n" * 2
    end
    violations.size.zero?
  end

  def get_violations(args)
    [
      [(args[:amount].is_a? Integer), "'amount' must be an 'Integer' type"],
      [args[:amount].positive?, "'amount' must be greater than zero"],
      [(args[:currency_from].is_a? String) && (args[:currency_to].is_a? String),
       "Currency abbreviation must be a 'String' type"],
      [(args[:currency_from].length == 3) && (args[:currency_to].length == 3),
       'Currency abbreviation length must be equals 3'],
      [(args[:currency_from].upcase == 'BYN') || @data.key?(args[:currency_from].upcase),
       "Currency '#{args[:currency_from].upcase}' not found"],
      [(args[:currency_to].upcase == 'BYN') || @data.key?(args[:currency_to].upcase),
       "Currency '#{args[:currency_to].upcase}' not found"]
    ].reject { |cond| cond[0] }.map { |i| i[1] }
  end

  def format_convert(money_from, money_to)
    "#{money_from.format} => #{money_to.format} :" \
      "(#{money_from.currency.name} => #{money_to.currency.name})"
  end

  def get_currency_params(currency)
    if currency == 'BYN'
      rate = 1
      scale = 1
    else
      rate = @data[currency]['Cur_OfficialRate']
      scale = @data[currency]['Cur_Scale']
    end
    { rate: rate, scale: scale }
  end
end
