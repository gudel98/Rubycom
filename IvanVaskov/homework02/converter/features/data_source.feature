Feature: Get data from source by type
  In order to get actual data from available source
  A user
  Should be able to get data from one of sources:
    JSON file;
    CSV file;
    web-API JSON

  Scenario: Get data by valid type and source is available
    Given the data types list [json, csv, web]
      And a stubbed class methods get_data
    When I try get data by type keys
    Then I should have calls count equals data types count
    Then I should get all the same expected responses

  Scenario: Try get data by invalid key or source is unavailable
    Given an invalid data type key
    When I try get data by for invalid type key
    Then I should get nil
