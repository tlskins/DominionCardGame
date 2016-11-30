FactoryGirl.define do
  factory :player do
    association :user
    association :game

    after(:build) do |player|
      player.played = build(:deck, status: 'Played')
      player.supply = build(:deck, status: 'Supply')
      player.hand = build(:deck, status: 'Hand')
      player.discard = build(:deck, status: 'Discard')
    end

  end
end

