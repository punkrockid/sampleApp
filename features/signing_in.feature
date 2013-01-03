Feature: Signing in

Scenario: Unsuccessful sign in
	Given a user visits the signin page
	When he submit invalid information
	Then he should see an error message

Scenario: Successful sign in
	Given a user visits the signin page
	And the user has an account
	And the user submits valid signin information
	Then he should see his profile page
	And he should see a signout link