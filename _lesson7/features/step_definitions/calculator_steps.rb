Given /^an input params$/ do
  @params = [5, 5, 5]
  Test.test
end

When /^I invoke caluclator$/ do
  @caluclator = Calculator.new
end

When /^I call sum method$/ do
  @result = @caluclator.sum(@params)
end

Then /^I receives correct response$/ do
  expect(@result).to eq(15)
end
