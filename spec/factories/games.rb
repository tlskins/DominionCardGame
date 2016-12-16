FactoryGirl.define do
  factory :game do
    status "In Progress"

    after(:build) do |game|
      game.gamemanager = build(:gamemanager)
      game.supply = build(:deck_three_cards)
      game.trash = build(:deck)
    end

    factory :game_three_players do
      after(:create) do |game|
        3.times { game.players << build(:player) }
      end
    end

  end
end
