require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  shared_examples "public access to users" do
    describe "GET #show" do
      before :each do
        @user = create(:user)
        get :show, id: @user.id
      end
      it "assigns the requested user to @user" do
        expect(assigns(:user)). to eq @user 
      end
      it "renders the :show template" do
        expect(response).to render_template :show
      end
    end

    describe "GET #new" do
      it "assigns a new User to @user" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST #create" do
      context "with valid attributes" do
        it "create new user" do
          count = User.count
          post :create, user: attributes_for(:user)
          expect(User.count).to eq(count + 1)
        end
        it "redirects to users#show" do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to user_path(assigns[:user])
        end
      end
      context "with invalid attributes" do
        it "does not save a new user" do
          count = User.count
          post :create, user: attributes_for(:user_nil_name)
          expect(User.count).to eq(count)
        end
        it "re-renders the :new template" do
          post :create, user: attributes_for(:user_nil_name)
          expect(response).to render_template :new
        end
      end
    end
  end 



shared_examples "full access to users" do
  describe "GET #index" do
    before :each do
      @tim = create(:user, name: "Tim")
      @jim = create(:user, name: "Jim")
      @kim = create(:user, name: "Kim")
      get :index
    end
    it "populates a paginated array of users" do
      expect(assigns(:users)).to match_array([@tim, @jim, @kim, @user])
    end
    it "renders the :index template" do
      expect(response).to render_template :index
    end
  end

  describe "POST #update" do
    context "with valid attributes" do
      it "locates the requested @user" do
        post :update, id: @user.id, user: attributes_for(:user)
        expect(assigns(:user)).to eq (@user)
      end
      it "updates the user's attributes in the database" do
        post :update, id: @user.id, user: attributes_for(:user, name: "Ron Swanson")
        @user.reload
        expect(@user.name).to eq("Ron Swanson")
      end
      it "redirects to the user" do
        post :update, id: @user.id, user: attributes_for(:user)
        expect(response).to redirect_to @user
      end
    end
    context "with invalid attributes" do
      it "does not update the attributes" do
        post :update, id: @user.id, user: attributes_for(:user_nil_name)
        expect(assigns(:user)).to eq (@user)
      end
      it " re-renders the :edit template" do
        post :update, id: @user.id, user: attributes_for(:user_nil_name)
        expect(response).to render_template :edit
      end
    end
  end
end



shared_examples "denied access to delete users" do 
  describe "DELETE #destroy" do
    before :each do
      @user_delete = create(:user)
    end
    it "does not delete the user from the database" do
      expect {
        delete :destroy, id: @user_delete.id
      }.to change(User,:count).by(0)
    end
    it "redirects to the root_url" do
      delete :destroy, id: @user_delete.id
      expect(response).to redirect_to root_url
    end
  end
end




shared_examples "admin access to users" do
  describe "DELETE #destroy" do
    before :each do
      @user_delete = create(:user)
    end
    it "deletes the user from the database" do
      expect { 
        delete :destroy, id: @user_delete.id
      }.to change(User,:count).by(-1)
    end
    it "redirects to the users#index" do
      delete :destroy, id: @user_delete.id
      expect(response).to redirect_to users_url
    end
  end
end


  
shared_examples "guest access to users" do
  describe "guest access" do
    describe "GET #index" do
      it "requires login" do
        get :index
        expect(response).to require_login
      end
    end
    describe "GET #edit" do
      it "requires login" do
        user = create(:user)
        get :edit, id: user.id
        expect(response).to require_login
      end
    end
    describe "POST #update" do
      it "requires login" do
        post :update, id: create(:user).id, user: attributes_for(:user)
        expect(response).to require_login
      end
    end
    describe "DELETE #destroy" do
      it "requires login" do
        delete :destroy, id: create(:user).id
        expect(response).to require_login
      end
    end
  end
end




describe "administrator access" do
  before :each do
    @user = create(:user_admin)
    log_in_as(@user)
  end
  it_behaves_like "public access to users"
  it_behaves_like "full access to users"
  it_behaves_like "admin access to users"
end

describe "user access" do
  before :each do
    @user = create(:user)
    log_in_as(@user)
  end
  it_behaves_like "public access to users"
  it_behaves_like "full access to users"
  it_behaves_like "denied access to delete users"
end

describe "guess access" do
  it_behaves_like "public access to users"
  it_behaves_like "guest access to users"
end 

end
