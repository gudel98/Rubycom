require 'money'
require 'json'
require 'colorize'
require 'rubocop'

class Converter
  
  attr_accessor :num_conv, :cur_name

  def initialize(num_conv, cur_name)
    current_path = File.dirname(__FILE__)
    file_path = File.read(current_path + "/converter.json")
    @file_hash = JSON.parse(file_path) 
    @num_conv = num_conv
    @cur_name = cur_name
    @cur_rate_eur = @file_hash["currency"][0]["cur_rate"]
    @cur_rate_usd = @file_hash["currency"][1]["cur_rate"]
    @cur_scale_rus = @file_hash["currency"][2]["cur_scale"]
    @cur_rate_rus = @file_hash["currency"][2]["cur_rate"]
  end

  def to_eur
    if cur_name == "BYN"
      (@num_conv.to_i / @cur_rate_eur).round(2)
    elsif cur_name == "USD"
      (@cur_rate_usd / @cur_rate_eur).round(2)
    elsif cur_name == "RUS"
      (@cur_rate_rus / @cur_scale_rus * @cur_rate_eur).round(2)
    else
      "Currency not found"
    end
  end

  def to_usd
    if cur_name == "BYN"
      (@num_conv.to_i / @cur_rate_usd).round(2)
    elsif cur_name == "EUR"
      (@cur_rate_eur / @cur_rate_usd).round(2)
    elsif cur_name == "RUS"
      (@cur_rate_rus / @cur_scale_rus * @cur_rate_usd).round(2)
    else
      "Currency not found"
    end
  end

  def to_rus
    if cur_name == "BYN"
      (@num_conv.to_i * @cur_scale_rus / @cur_rate_rus).round(2)
    elsif cur_name == "USD"
      (@cur_rate_usd * @cur_scale_rus / @cur_rate_rus).round(2)
    elsif cur_name == "EUR"
      (@cur_rate_eur * @cur_scale_rus / @cur_rate_rus).round(2)
    else
      "Currency not found"
    end
  end

  def to_byn
    if @cur_name == "EUR" 
      (@num_conv.to_i * @cur_rate_eur).round(2)
    elsif @cur_name == "USD"
      (@num_conv.to_i * @cur_rate_usd).round(2)
    elsif @cur_name == "RUS" && @num_conv >= '100'
      (@num_conv.to_i / @cur_scale_rus * @cur_rate_rus).round(2)
    else
      "Currency not found or must be >= 100"
    end
  end

  def self.convert(num_conv, cur_from, cur_to)
    current_path = File.dirname(__FILE__)
    file_path = File.read(current_path + "/converter.json")
    @file_hash = JSON.parse(file_path)
    @num_conv = num_conv
    @cur_from = cur_from
    @cur_to = cur_to

    if @cur_from == 'USD' && @cur_to == 'EUR'
      (@num_conv.to_i * @cur_rate_usd / @cur_rate_eur).round(2)
    elsif @cur_from == 'EUR' && @cur_to == 'USD'
      (@num_conv.to_i * @cur_rate_eur / @cur_rate_usd).round(2)
    elsif @cur_from == 'EUR' && @cur_to == 'RUS'
      (@num_conv.to_i * @cur_rate_eur * @cur_scale_rus / @cur_rate_rus).round(2)
    elsif @cur_from == 'RUS' && @cur_to == 'EUR'
      (@num_conv.to_i / @cur_scale_rus * @cur_rate_rus / @cur_rate_rus).round(2)
    elsif @cur_from == 'USD' && @cur_to == 'RUS'
      (@num_conv.to_i * @cur_rate_usd / @cur_scale_rus / @cur_rate_rus).round(2)
    elsif @cur_from == 'RUS' && @cur_to == 'USD'
      (@num_conv.to_i / @cur_scale_rus * @cur_rate_rus / @cur_rate_usd).round(2)
    else
      "Currency not found"
    end
  end
end
converter = Converter.new(1.00, 'RUS')
puts converter.to_byn