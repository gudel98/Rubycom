require_relative './spec_helper.rb'

class TestDataUtils
  extend DataUtils
end

describe DataUtils do
  include_context 'shared stub data'

  it 'checks getting raw json from web' do
    stub_request(:get, 'http://nbrb.by').
      to_return(status: 200, body: @stub_raw_data.to_json,
        headers: {
          'Content-Type'=>'application/json; charset=utf-8',
        })

    expect(TestDataUtils.send(:get_raw_json, 'http://nbrb.by')).
      to eq(@stub_raw_data)
  end

  it 'checks writing hash to the JSON file' do
    TestDataUtils.send(:hash_to_json_file, @stub_data, __dir__)
    expect(File).to exist("#{__dir__}/data.json")
  end

  it 'checks writing json data to the CSV file' do
    TestDataUtils.send(:raw_json_to_csv_file, @stub_raw_data, __dir__)
    expect(File).to exist("#{__dir__}/data.csv")
  end
end
