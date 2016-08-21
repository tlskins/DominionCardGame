User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
	     admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end


Cardmapping.create!(name:  "Copper",
             text: "Copper",
             is_treasure: true,
	     treasure_amount: 1,
	     cost: 0)

Cardmapping.create!(name:  "Estate",
             text: "Estate",
             is_victory: true,
	     victory_points: 1,
	     cost: 2)
