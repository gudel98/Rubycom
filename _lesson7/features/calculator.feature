Feature: test-case for calculator

  Scenario: sum method
    Given an input params
     When I invoke caluclator
      And I call sum method
     Then I receives correct response
