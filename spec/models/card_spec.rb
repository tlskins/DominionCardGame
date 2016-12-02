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

  subject { build(:action_card) }
  it {  is_expected.to have_card_type "action" }

  subject { build(:attack_card) }
  it { expect(cardmapping.is_attack).to eq(true) }

  subject { build(:reaction_card) }
  it { expect(cardmapping.is_reaction).to eq(true) }

  subject { build(:treasure_card) }
  it { expect(cardmapping.is_treasure).to eq(true) }

  subject { build(:victory_card) }
  it { expect(cardmapping.is_victory).to eq(true) }



  it { should belong_to (:cardmapping) }
end

