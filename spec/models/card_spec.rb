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

  it { should belong_to (:cardmapping) }
end

