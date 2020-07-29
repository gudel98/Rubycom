require 'converter'
#require_relative './data_utils'

include DataUtils

path = File.expand_path(File.dirname(__FILE__))
p path
data_clazz = DataFactory.for('web')
con = Converter.new(data_clazz.get_data)
p con.convert(120, 'byn', 'EuR')
p con.convert(10, 'EuR', 'uSd')


hash_to_json_file(DataFactory.for('web').get_data, path) # create data.json from json_hash

data_clazz = DataFactory.for('json')
con = Converter.new(data_clazz.get_data("#{path}/data.json"))
p con.convert(120, 'byn', 'EuR')
p con.convert(10, 'EuR', 'uSd')


raw_json_to_csv_file(get_raw_json, path) # create data.csv from raw_json

data_clazz = DataFactory.for('csv')
con = Converter.new(data_clazz.get_data("#{path}/data.csv"))
p con.convert(120, 'byn', 'EuR')
p con.convert(10, 'EuR', 'uSd')
