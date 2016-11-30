FactoryGirl.define do
  factory :cardmapping do
    sequence(:name) { |n| "Test Card Mapping#{n}" }
    text "Test Card Mapping Text"
    cost 1

    factory :action_cardmapping do
      is_action true
    end

    factory :attack_cardmapping do
      is_attack true
    end

    factory :reaction_cardmapping do
      is_reaction true
    end

    factory :treasure_cardmapping do
      is_treasure true
      treasure_amount 1
    end

    factory :victory_cardmapping do
      is_victory true
      victory_points 1 
    end
  end
end

