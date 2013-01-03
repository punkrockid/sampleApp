FactoryGirl.define do
	factory :user do
		name		("Israel")
		email		("my@mail.com")
		password	("qwerty")
		password_confirmation("qwerty")
	end
end