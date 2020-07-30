require 'converter'

include DataUtils

SOURCE_TYPES = %w[web json csv]
path = File.expand_path(File.dirname(__FILE__))
web_source = 'https://www.nbrb.by/api/exrates/rates?periodicity=0'

# create data.json from json_hash
hash_to_json_file(DataFactory.for('web').get_data(web_source), path)

# create data.csv from raw_json
raw_json_to_csv_file(get_raw_json(web_source), path)

SOURCE_TYPES.each do |i|
  data_clazz = DataFactory.for(i)
  source = (i == 'web') ? web_source: "#{path}/data.#{i}"
  con = Converter.new(data_clazz.get_data(source))
  p con.convert(120, 'byn', 'EuR')
  p con.convert(10, 'EuR', 'uSd')
end
