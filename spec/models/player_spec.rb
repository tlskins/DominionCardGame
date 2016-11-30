require 'rails_helper'

RSpec.describe Player, type: :model do
  it "has a valid factory" do
    expect(build(:player)).to be_valid
  end
 
  it "creates player decks in the factory" do
    player = create(:player)
    expect(player.supply).to be_valid
    expect(player.hand).to be_valid
    expect(player.discard).to be_valid
    expect(player.played).to be_valid
  end

  it { should belong_to (:user) }
end

