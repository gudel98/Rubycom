Given /^entering the name and amount of currency to exchange$/ do
    @num_conv = ('1.00')
    @cur_name = ('USD')
end

When /^I invoke converter$/ do
  @converter = Converter.new(@num_conv,@cur_name)
end

When /^I call to_eur method$/ do
  @result = @converter.to_eur
end 

Then /^I receives correct response$/ do
  expect(@result).to eq(0.85)
end
  



