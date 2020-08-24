Given('the data types list [json, csv, web]') do
  SOURCE_TYPES = %w[web json csv].freeze
end

Given('a stubbed class methods get_data') do
  @expected_data = {"BYN" => 1}
  SOURCE_TYPES.each do |i|
    clazz = DataFactory.for(i)
    allow(clazz)
      .to receive(:get_data).with('')
      .and_return(@expected_data)
  end
end

Given('an invalid data type key') do
  @invalid_type = 'invalid'
end

When('I try get data by type keys') do
  @result_data = []
  SOURCE_TYPES.each do |i|
    @result_data << DataFactory.for(i).get_data('')
  end
end

When('I try get data by for invalid type key') do
  @data_clazz = DataFactory.for(@invalid_type)
end

Then('I should have calls count equals data types count') do
  expect(@result_data.size).to eq(SOURCE_TYPES.size)
end

Then('I should get all the same expected responses') do
  expect(@result_data).to all eq(@expected_data)
end

Then('I should get nil') do
  expect(@data_clazz).to eq(nil)
end
