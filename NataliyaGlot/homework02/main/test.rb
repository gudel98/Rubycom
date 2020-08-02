require 'converter'
require 'pry'

converter = Converter.new('1.00', 'USD')
	puts converter.to_eur # => Пример вывода: '$1 = €0.87 (<здесь информация про конвертируемые валюты>)'
	puts converter.to_byn
	puts converter.to_rub

	# Допустимы другие варианты реализации, к примеру:
	puts Converter.convert('1.00', 'USD', 'EUR') # amount, currency_from, currency_to
	# => Пример вывода: '$1 = €0.87 (<здесь информация про конвертируемые валюты>)'

