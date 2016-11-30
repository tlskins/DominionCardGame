FactoryGirl.define do
  factory :deck do

    factory :deck_three_cards do
      after(:build) do |deck|
        3.times { deck.cards << build(:card) }
      end
    end

  end
end

