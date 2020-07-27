require 'converter'

data_clazz = DataFactory.for('json')
cnv = Converter.new(data_clazz.get_data)
p cnv.convert(10, 'byn', 'EuR')
p cnv.convert(1, 'EuR', 'uSd')

data_clazz = DataFactory.for('json')
cnv = Converter.new(data_clazz.get_data)
p cnv.convert(10, 'byn', 'EuR')
p cnv.convert(1, 'EuR', 'uSd')
