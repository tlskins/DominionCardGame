require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  describe "validity by attributes" do
    before :each do
      user = create(:user, name: "Gymothy", email: "timothy1234567@gmail.com")
    end

    context "duplicate email address" do
      it "is invalid" do
        dup_user = build(:user, email: "timothy1234567@gmail.com")
        expect(dup_user).not_to be_valid
        expect(dup_user.errors[:email]).to include("has already been taken")
      end
    end

    context "duplicate name" do
      it "is valid" do
        dup_user = build(:user, name: "Timothy")
        dup_user.valid?
        expect(dup_user).to be_valid
      end
    end
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
end
