require 'converter'
require 'pry'

converter = Converter.new('1.00', 'USD')
puts converter.to_eur 
puts converter.to_byn
puts converter.to_rub

puts Converter.convert('1.00', 'USD', 'EUR')