require 'rails_helper'

RSpec.describe GamesController, type: :controller do

describe 'GET #index' do
  let(:game) { build_stubbed(:game) }
  let(:user1) { build_stubbed(:user, name: 'Tim', email: 'tim@email.com', games: [game]) }
  before :each do
    log_in_as(user1)
    allow(User).to receive(:find).and_return(user1)
    get :index, id: user1.id
  end
  it "assigns the game to the @games list" do
    expect(assigns(:games)).to eq [game]
  end
  it "renders the :index template" do
    expect(response).to render_template :index
  end
end
  
describe 'GET #show' do
  before :all do
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
  end
  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    @game = Game.create_game_for(@user1.id, [@user2])
    @player1 = Player.find_by(user_id: @user1.id, game_id: @game.id)
    log_in_as(@user1)
    get :show, id: @game.id
  end
  it "assigns the requested game" do
    expect(assigns(:game)).to eq @game
  end
  it "assigns the correct player" do
    expect(assigns(:player)).to eq @player1
  end
  it "assigns the correct supply cards" do
    expect(assigns(:supply_cards)).to eq @game.generate_supply_cards_hash
  end
  it "renders the show template" do
    expect(response).to render_template :show
   end
  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end
end

describe 'GET #new' do
  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    log_in_as(@user1)
    get :new
  end
  it "assigns game players as nil" do
    expect(assigns(:game_players)).to be_nil
  end
  it "assigns game users as an empty array" do
    expect(assigns(:game_users)).to eq []
  end
  it "assigns available users as all users except current user" do
    expect(assigns(:avail_users)).to include @user2
    expect(assigns(:avail_users)).to_not include @user1
  end
  it "assigns creator id as current user id" do
    expect(assigns(:creator_id)).to eq @user1.id
  end
  it "renders the new template" do
    expect(response).to render_template :new
  end
end


describe 'POST #addplayer' do
  before :each do 
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    @user4 = create(:user)
    log_in_as(@user1)
  end
  context "adding first player to a game" do
    before :each do
      post :addplayer, player: @user2.id, game_players: []
    end
    it "assigns the correct creator id" do
      expect(assigns(:creator_id)).to eq @user1.id
    end
    it "assigns game players correctly" do
      expect(assigns(:game_players)).to include @user2.id.to_s
    end
    it "assigns available users without any players added already" do
      expect(assigns(:avail_users)).to_not include(@user2, @user1)
      expect(assigns(:avail_users)).to include(@user3, @user4)
    end
    it "re-renders the new form" do 
      expect(response).to render_template :new
    end
  end
  context "adding second player to a game" do
    before :each do
      post :addplayer, player: @user3.id, game_players: @user2.id
    end
    it "assigns game players correctly" do
      expect(assigns(:game_players)).to include(@user2.id.to_s, @user3.id.to_s)
    end
    it "assigns available users withouth any players added already" do
      expect(assigns(:avail_users)).to_not include(@user1.id.to_s, @user2.id.to_s, @user3.id.to_s)
    end
    it "re-renders the new form" do
      expect(response).to render_template :new
    end
  end
  context "adding third player to a game" do
    before :each do
      post :addplayer, player: @user4.id, game_players: @user2.id.to_s + ',' + @user3.id.to_s
    end
    it "assigns game players correctly" do
      expect(assigns(:game_players)).to include(@user2.id.to_s, @user3.id.to_s, @user4.id.to_s)
    end
    it "assigns available users withouth any players added already" do
      expect(assigns(:avail_users)).to_not include(@user1.id.to_s, @user2.id.to_s, @user3.id.to_s, @user4.id.to_s)
    end
    it "re-renders the new form" do
      expect(response).to render_template :new
    end
  end
end


shared_examples "valid game creation behavior" do
  it "gives the creator the first turn" do
    expect(Player.find(assigns(:game).gamemanager.player_turn).user_id).to eq @user1.id
  end
  it "creates a new valid game object" do
    expect(assigns(:game)).to be_valid
  end
  it "creates status with In Progress" do
    expect(assigns(:game).status).to eq 'In Progress'
  end
  it "re directs to game" do
    expect(response).to redirect_to game_path(id: assigns(:game).id)
  end
end

describe "POST #create" do
  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    log_in_as(@user1)
  end
  context "create game with 2 total players" do
    before :each do
      post :create, game_players: @user2.id.to_s
    end
    it_behaves_like "valid game creation behavior"
  end
  context "create game with 3 total players" do
    before :each do
      post :create, game_players: @user2.id.to_s + ',' + @user3.id.to_s
    end
    it_behaves_like "valid game creation behavior"
  end
  it "redirects to the new page if there are no game players" do
    post :create, game_players: nil
    expect(response).to render_template :new
  end
end

describe "DELETE #destroy" do
  context "delete game as creator" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      log_in_as(@user1)
      @game = Game.create_game_for(@user1.id, [@user2])
    end
    it "deletes the game when the creator deletes the game" do
      expect {
        delete :destroy, id: @game.id
      }.to change(Game,:count).by(-1)
    end
    it "redirects to the root_url" do
      delete :destroy, id: @game.id
      expect(response).to redirect_to user_games_path(@user1.id)
    end
  end
  context "delete game not as creator" do
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      log_in_as(@user1)
      @game = Game.create_game_for(@user1.id, [@user2])
      log_in_as(@user2)
    end
    it "does not delete the game" do
      expect {
        delete :destroy, id: @game.id
      }.to change(Game,:count).by(0)
    end
    it "redirects to the root_url" do
      delete :destroy, id: @game.id
      expect(response).to redirect_to user_games_path(@user2.id)
    end
  end
end

end
