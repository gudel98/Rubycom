Given /^an input params$/ do
  @params = [5, 5, 5]
  Test.test
end

Given /^a stubbed instance method$/ do
  allow_any_instance_of(Calculator)
    .to receive(:sum)
    .with(@params)
    .and_return(123456789)
end

Given /^a stubbed class method$/ do
  allow(Calculator)
    .to receive(:foo)
    .and_return(123456789)
end

When /^I invoke caluclator$/ do
  @caluclator = Calculator.new
end

When /^I call sum method$/ do
  @result = @caluclator.sum(@params)
end

When /^I call foo method$/ do
  @result = Calculator.foo
end

Then /^I receives correct response$/ do
  expect(@result).to eq(15)
end

Then /^I receives stubbed response$/ do
  expect(@result).to eq(123456789)
end
