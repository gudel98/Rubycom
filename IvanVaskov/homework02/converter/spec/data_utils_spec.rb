require_relative './spec_helper.rb'

describe DataUtils do
  include_context 'shared stub data'

  it 'checks getting raw json from web' do
    stub_request(:get, 'http://nbrb.by').
      to_return(status: 200, body: @stub_raw_data.to_json,
        headers: {
          'Content-Type'=>'application/json; charset=utf-8',
        })

    expect(subject.get_raw_json('http://nbrb.by')).
      to eq(@stub_raw_data)
  end

  it 'checks writing hash to the JSON file' do
    path = "#{__dir__}/data.json"
    File.delete(path) if File.exist?(path)
    subject.hash_to_json_file(@stub_data, __dir__)
    expect(File).to exist(path)
  end

  it 'checks writing JSON data to the CSV file' do
    path = "#{__dir__}/data.csv"
    File.delete(path) if File.exist?(path)
    subject.raw_json_to_csv_file(@stub_raw_data, __dir__)
    expect(File).to exist(path)
  end
end
