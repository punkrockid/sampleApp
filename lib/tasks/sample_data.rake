namespace :db do
	desc "Fill db with sample data"
	task populate: :environment do
		admin=User.create!(name: "Example usr",
			email: "example@railstutorial.org",
			password: "123123",
			password_confirmation: "123123")
		admin.toggle!(:admin)
		99.times do |n|
			name=Faker::Name.name
			email="example-#{n+1}@railstutorial.org"
			password="123123"
			User.create!(name: name, email: email,
				password: password, password_confirmation: password)
		end
	end
end