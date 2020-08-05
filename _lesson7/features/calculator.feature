Feature: test-case for calculator

  Scenario: sum method
    Given an input params
     When I invoke caluclator
      And I call sum method
     Then I receives correct response

  Scenario: stub instance method
    Given an input params
      And a stubbed instance method
     When I invoke caluclator
      And I call sum method
     Then I receives stubbed response

  Scenario: stub class method
    Given an input params
      And a stubbed class method
     When I call foo method
     Then I receives stubbed response
