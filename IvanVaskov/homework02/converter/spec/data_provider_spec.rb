require_relative './spec_helper.rb'

describe DataFactory do
  context "when 'for' method called with valid arguments" do
    it "returns correct class by 'web' parameter" do
      expect(DataFactory.for('web')).to eq(WebData)
    end

    it "returns correct class by 'json' parameter" do
      expect(DataFactory.for('json')).to eq(JsonData)
    end

    it "returns correct class by 'csv' parameter" do
      expect(DataFactory.for('csv')).to eq(CsvData)
    end
  end

  context "when 'for' method get invalid arguments" do
    it "returns nil for not 'String' parameter" do
      expect(DataFactory.for(1.0)).to eq(nil)
    end

    it "returns nil for invalid parameter value" do
      expect(DataFactory.for('jgj')).to eq(nil)
    end
  end
end

describe AbstractData do
  it "raises exception if 'get_data' was call" do
    expect { subject.class.get_data(nil) }.to raise_error(NotImplementedError)
  end

  it "implements '.error_handler' method" do
    expect(subject.class).to respond_to(:error_handler)
  end
end

describe WebData do
  include_context 'shared stub data'

  it 'returns nil for invalid URI' do
    WebMock.allow_net_connect!
    expect(subject.class.get_data('ht://m')).to eq(nil)
    WebMock.disable_net_connect!
  end

  it 'returns nil for invalid JSON response' do
    stub_request(:get, 'http://nbrb.by').
      to_return(status: 200, body: '',
        headers: {
          'Content-Type'=>'application/json; charset=utf-8',
        })
    expect(subject.class.get_data('http://nbrb.by')).to eq(nil)
  end

  it "checks main scenario with valid 'in data source'" do
    stub_request(:get, 'http://nbrb.by').
      to_return(status: 200, body: @stub_raw_data.to_json,
        headers: {
          'Content-Type'=>'application/json; charset=utf-8',
        })
    expect(subject.class.get_data('http://nbrb.by')).
      to eq(@stub_data)
  end
end

describe JsonData do
  include_context 'shared stub data'

  it 'returns nil for invalid file path' do
    expect(subject.class.get_data('/eee.json')).to eq(nil)
  end

  it 'returns nil for invalid JSON data' do
    expect(subject.class.get_data("#{__dir__}/invalid.txt")).to eq(nil)
  end

  it "checks main scenario with valid 'in data source'" do
    expect(subject.class.get_data("#{__dir__}/data.json")).
      to eq(@stub_data)
  end
end

describe CsvData do
  include_context 'shared stub data'

  it 'returns nil for invalid file path' do
    expect(subject.class.get_data('/eee.csv')).to eq(nil)
  end

  it 'returns nil for invalid CSV data' do
    expect(subject.class.get_data("#{__dir__}/invalid.txt")).to eq(nil)
  end

  it "checks main scenario with valid 'in data source'" do
    expect(subject.class.get_data("#{__dir__}/data.csv")).
      to eq(@stub_data)
  end
end
