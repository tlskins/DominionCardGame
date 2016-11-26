require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do

    context "with valid attributes" do
      it "create new user" do
        count = User.count
        post :create, user: FactoryGirl.attributes_for(:user)
        expect(User.count).to eq(count + 1)
      end
    end

    context "with invalid attributes" do
      it "does not create a new user" do
        count = User.count
        post :create, user: FactoryGirl.attributes_for(:user, :password => nil)
        expect( response ).to render_template :new
        expect(User.count).to eq(count)
      end
    end

  end
end
