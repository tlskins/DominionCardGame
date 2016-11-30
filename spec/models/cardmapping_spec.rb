require 'rails_helper'


RSpec.describe Cardmapping, type: :model do
  it "has a valid factory" do
    expect(build(:cardmapping)).to be_valid
  end

  it "has valid specific cardmapping factories" do
    expect(build(:action_cardmapping)).to be_valid
    expect(build(:attack_cardmapping)).to be_valid
    expect(build(:reaction_cardmapping)).to be_valid
    expect(build(:treasure_cardmapping)).to be_valid
    expect(build(:victory_cardmapping)).to be_valid
  end

  it "is invalid without a name" do
    cardmapping = build(:cardmapping, name: nil)
    expect(cardmapping).not_to be_valid
    expect(cardmapping.errors[:name]).to include("can't be blank")
  end

  it "is invalid without text" do
    cardmapping = build(:cardmapping, text: nil)
    expect(cardmapping).not_to be_valid
    expect(cardmapping.errors[:text]).to include("can't be blank")
  end

  it "is invalid without cost" do
    cardmapping = build(:cardmapping, cost: nil)
    expect(cardmapping).not_to be_valid
    expect(cardmapping.errors[:cost]).to include("can't be blank")
  end


  describe "validity by duplicate attributes" do
    before :each do
      cardmapping = create(:cardmapping, name: "Test Card Mapping")
    end

    context "duplicate name" do
      it "is invalid" do
        dup_cardmapping = build(:cardmapping, name: "Test Card Mapping")
        expect(dup_cardmapping).not_to be_valid
        expect(dup_cardmapping.errors[:name]).to include("has already been taken")
      end
    end

    context "duplicate uppercase name" do
      it "is invalid" do
        dup_cardmapping = build(:cardmapping, name: "TEST CARD MAPPING")
        expect(dup_cardmapping).not_to be_valid
        expect(dup_cardmapping.errors[:name]).to include("has already been taken")
      end
    end

    context "duplicate text" do
      it "is valid" do
        dup_cardmapping = build(:cardmapping, name: "Test Card Text")
        expect(dup_cardmapping).to be_valid
      end
    end
  end

  context "treasure cardmapping" do
    it "is invalid without a treasure amount" do
      cardmapping = build(:treasure_cardmapping, treasure_amount: nil)
      expect(cardmapping).not_to be_valid
      expect(cardmapping.errors[:treasure_amount]).to include("can't be blank")
    end
  end

  context "victory cardmapping" do
    it "is invalid without victory points" do
      cardmapping = build(:victory_cardmapping, victory_points: nil)
      expect(cardmapping).not_to be_valid
      expect(cardmapping.errors[:victory_points]).to include("can't be blank")
    end
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:text) }
  it { is_expected.to validate_presence_of(:cost) }
end

