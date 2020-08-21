# frozen_string_literal: true

require 'converter'
require 'pry'

SOURCE_TYPES = %w[web json csv].freeze

# It is the test class for Converter
class TestConverter
  def self.test
    web_source = 'https://www.nbrb.by/api/exrates/rates?periodicity=0'
    # create data.json from json_hash
    DataUtils.hash_to_json_file(DataFactory.for('web').get_data(web_source), __dir__)
    # create data.csv from raw_json
    DataUtils.raw_json_to_csv_file(DataUtils.get_raw_json(web_source), __dir__)
    SOURCE_TYPES.each do |i|
      data_clazz = DataFactory.for(i)
      source = i == 'web' ? web_source : "#{__dir__}/data.#{i}"
      con = Converter.new(data_clazz.get_data(source))
      con.convert(120_00, 'byn', 'EuR')
      con.convert(10, 'EuR', 'uSd')
      con.convert(-1, 'by', 'uSR')
    end
  end
end

TestConverter.test
