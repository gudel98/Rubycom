Feature: test_case for currency converter

  Scenario: make an exchange with the converter
    Given entering the name and amount of currency to exchange
     When I invoke converter
      And I call to_eur method
     Then I receives correct response