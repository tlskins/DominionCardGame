User.create!(name:  "testExample User",
             email: "testexample@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
	     admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "testexample-#{n+1}@railstutorial.org"
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

Cardmapping.create!(name:  "Silver",
             text: "Silver",
             is_treasure: true,
             treasure_amount: 2,
             cost: 3)

Cardmapping.create!(name:  "Gold",
             text: "Gold",
             is_treasure: true,
             treasure_amount: 3,
             cost: 6)

Cardmapping.create!(name:  "Estate",
             text: "Estate",
             is_victory: true,
	     victory_points: 1,
	     cost: 2)

Cardmapping.create!(name: "Village",
	     text: "+1 Card & +2 Actions",
	     is_action: true,
	     cost: 3)
             

