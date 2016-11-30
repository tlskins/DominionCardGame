require 'rails_helper'

RSpec.describe Deck, type: :model do
  it "has a valid factory" do
    expect(build(:deck)).to be_valid
  end

  it "has 3 cards" do
    expect(create(:deck_three_cards).cards.count).to eq 3
  end

end

