require 'rails_helper'

RSpec.describe Card, type: :model do
  it "has a valid factory" do
    expect(build(:card)).to be_valid
    expect(build(:action_card)).to be_valid
    expect(build(:attack_card)).to be_valid
    expect(build(:reaction_card)).to be_valid
    expect(build(:treasure_card)).to be_valid
    expect(build(:victory_card)).to be_valid
  end

  # Check card order in deck model spec

  
  # Duplicate test to illustrate how to use expect vs is_expected
  it "sets the card type correctly for action card factory" do
    card = build(:action_card)
    expect(card).to have_card_type "action"
  end

  it { is_expected.to belong_to (:cardmapping) }

  # difference between expect(actual).to and is_expected.to ???

  # difference between should vs expect ???
  #  should is old syntax
  
  context "action cards" do
    subject { build(:action_card) }
    it {  is_expected.to have_card_type "action" }
  end

  context "attack cards" do
    subject { build(:attack_card) }
    it {  is_expected.to have_card_type "attack" }
  end

  context "reaction cards" do
    subject { build(:reaction_card) }
    it {  is_expected.to have_card_type "reaction" }
  end

  context "treasure cards" do
    subject { build(:treasure_card) }
    it {  is_expected.to have_card_type "treasure" }
  end

  context "victory cards" do
    subject { build(:victory_card) }
    it {  is_expected.to have_card_type "victory" }
  end

end

