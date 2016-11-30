FactoryGirl.define do
  factory :card do
    association :cardmapping

    factory :action_card do
      cardmapping { build(:action_cardmapping) }
    end

    factory :attack_card do
      cardmapping { build(:attack_cardmapping) }
    end

    factory :reaction_card do
      cardmapping { build(:reaction_cardmapping) }
    end

    factory :treasure_card do
      cardmapping { build(:treasure_cardmapping) }
    end

    factory :victory_card do
      cardmapping { build(:victory_cardmapping) }
    end
  end
end

