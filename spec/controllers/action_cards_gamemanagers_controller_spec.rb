require 'rails_helper'

RSpec.describe GamemanagersController, type: :controller do


describe 'Mine Card' do 
describe 'POST #play_card_action - Action Phase - Trash' do
  before :all do
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
  end
  before :each do
    @user1 = create(:user)
    @user2 = create(:user)
    log_in_as(@user1)
    #post :create, controller: 'games', game_players: @user2.id.to_s
    @game = Game.create_game_for(@user1.id, [@user2])
    @game.initialize_player_cards
    @player1 = Player.find_by(user_id: @user1.id, game_id: @game.id)
    @card1 = @player1.hand.cards.first
    @card1.update_attributes( cardmapping_id: Cardmapping.get('Copper') )
    #post "/games/" + @game.id.to_s + "/gamemanagers/" + @game.gamemanager.id.to_s + "/play_card_action", action_hash: "{\"Trash\"=>[" + @card1.id.to_s + "]}" 
    post gamemanager_play_card_action_path( id: @game.id, gamemanager_id: @game.gamemanager.id ), action_hash: "{\"Trash\"=>[" + @card1.id.to_s + "]}"
  end
  it "assigns the requested game" do
    expect(assigns(:game)).to eq @game
  end
  it "assigns the correct selectable supply cards" do
    expect(assigns(:selectable_supply_array)).to contain('Silver')
    expect(assigns(:selectable_supply_array)).to contain('Copper')
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
end

end
