require 'converter'
require_relative 'data_utils'

include DataUtils
p __FILE__
p File.dirname(__FILE__)
=begin
data_clazz = DataFactory.for('web')
cnv = Converter.new(data_clazz.get_data)
p cnv.convert(10, 'byn', 'EuR')
p cnv.convert(1, 'EuR', 'uSd')

data_clazz = DataFactory.for('json')
cnv = Converter.new(data_clazz.get_data)
p cnv.convert(10, 'byn', 'EuR')
p cnv.convert(1, 'EuR', 'uSd')

data_clazz = DataFactory.for('csv')
cnv = Converter.new(data_clazz.get_data)
p cnv.convert(10, 'byn', 'EuR')
p cnv.convert(1, 'EuR', 'uSd')
=end
