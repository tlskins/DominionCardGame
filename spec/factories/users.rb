FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password { "foobar" }
    password_confirmation { "foobar" }
  end

  factory :timuser do
    name     { "timothy lee" }
    email    { "timothy@gmail.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end

end
