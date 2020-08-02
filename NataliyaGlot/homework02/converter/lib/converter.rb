require 'money'
require 'json'
require 'colorize'
require 'pry'
class Converter
  
    attr_accessor :num_conv, :cur_name

    def initialize(num_conv, cur_name)
      file = File.read('converter.json')
      @file_hash = JSON.parse(file)
      @num_conv = num_conv
      @cur_name = cur_name
    end

    def to_eur
      @cur_scale = @file_hash["currency"][0]["cur_scale"]
      @cur_rate = @file_hash["currency"][0]["cur_rate"]
      (@num_conv * @cur_scale / @cur_rate).round(2)
    end

    def to_usd
      @cur_scale = @file_hash["currency"][1]["cur_scale"]
      @cur_rate = @file_hash["currency"][1]["cur_rate"]
      (@num_conv * @cur_scale / @cur_rate).round(2)
    end

    def to_rus
      @cur_scale = @file_hash["currency"][2]["cur_scale"]
      @cur_rate = @file_hash["currency"][2]["cur_rate"]
      (@num_conv * @cur_scale / @cur_rate).round(2)
    end

    def to_byn
      if @cur_name == "EUR" 
        @cur_scale = @file_hash["currency"][0]["cur_scale"]
        @cur_rate = @file_hash["currency"][0]["cur_rate"]
        (@num_conv / @cur_scale * @cur_rate).round(2)
      elsif @cur_name == "USD"
        @cur_scale = @file_hash["currency"][1]["cur_scale"]
        @cur_rate = @file_hash["currency"][1]["cur_rate"]
        (@num_conv / @cur_scale * @cur_rate).round(2)
      elsif @cur_name == "RUS"
        @cur_scale = @file_hash["currency"][2]["cur_scale"]
        @cur_rate = @file_hash["currency"][2]["cur_rate"]
        (@num_conv / @cur_scale * @cur_rate).round(2)
      else
        "Currency not found"
      end
    end

    def self.convert(num_conv, cur_from, cur_to)
      file = File.read('converter.json')
      @file_hash = JSON.parse(file)
      @num_conv = num_conv
      @cur_from = cur_from
      @cur_to = cur_to
        if @cur_from == 'USD' && @cur_to == 'EUR'
          @cur_scale = @file_hash["currency"][1]["cur_scale"]
          @cur_rate = @file_hash["currency"][1]["cur_rate"]
          ((@num_conv / @cur_scale * @cur_rate) / @file_hash["currency"][0]["cur_rate"]).round(2)
        elsif @cur_from == 'EUR' && @cur_to == 'USD'
          @cur_scale = @file_hash["currency"][0]["cur_scale"]
          @cur_rate = @file_hash["currency"][0]["cur_rate"]
          (@num_conv / @cur_scale * @cur_rate) / @file_hash["currency"][1]["cur_rate"].round(2)
        elsif @cur_from == 'EUR' && @cur_to == 'RUS'
          @cur_scale = @file_hash["currency"][0]["cur_scale"]
          @cur_rate = @file_hash["currency"][0]["cur_rate"]
          (@num_conv / @cur_scale * @cur_rate) * @file_hash["currency"][2]["cur_scale"] / @file_hash["currency"][2]["cur_rate"].round(2)
        elsif @cur_from == 'RUS' && @cur_to == 'EUR'
          @cur_scale = @file_hash["currency"][2]["cur_scale"]
          @cur_rate = @file_hash["currency"][2]["cur_rate"]
          (@num_conv / @cur_scale * @cur_rate) / @file_hash["currency"][0]["cur_rate"].round(2)
        elsif @cur_from == 'USD' && @cur_to == 'RUS'
          @cur_scale = @file_hash["currency"][1]["cur_scale"]
          @cur_rate = @file_hash["currency"][1]["cur_rate"]
          (@num_conv / @cur_scale * @cur_rate) / @file_hash["currency"][2]["cur_scale"] / @file_hash["currency"][2]["cur_rate"].round(2)
        elsif @cur_from == 'RUS' && @cur_to == 'USD'
          @cur_scale = @file_hash["currency"][2]["cur_scale"]
          @cur_rate = @file_hash["currency"][2]["cur_rate"]
          (@num_conv / @cur_scale * @cur_rate) / @file_hash["currency"][1]["cur_rate"].round(2)
        else
          "Currency not found"
        end
    end
end


#puts Converter.convert(100, 'USD', 'EUR')
converter = Converter.new(100,"EUR")
binding.pry 


