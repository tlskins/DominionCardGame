FactoryGirl.define do
  factory :user do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password { "foobar" }
    password_confirmation { "foobar" }
    
    factory :user_nil_name do
      name nil
    end
    
    factory :user_nil_email do
      email nil
    end

    factory :user_nil_password do
      password nil
    end
   
    factory :user_admin do
      admin true
    end
  end
end
