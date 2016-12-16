require 'rails_helper'

RSpec.describe Game, type: :model do

  describe "has valid factories" do
    context "default game factory" do
      before :each do
        @game = build(:game)
      end
      it "creates a valid game object" do
        expect(@game).to be_valid
      end
      it "has a supply deck" do
        expect(@game.supply).to_not be_nil
      end
      it "has a trash deck" do
        expect(@game.trash).to_not be_nil
      end
      it "has a gamemamanger" do
        expect(@game.gamemanager).to_not be_nil
      end
    end 
    it "has a valid 3 player game factory" do
      game = create(:game_three_players)
      expect(game.players.count).to eq 3
    end
  end

  describe "correctly sets up a new game" do
    before :all do
      DatabaseCleaner.clean_with(:truncation)
      load "#{Rails.root}/db/seeds.rb"
    end
    before :each do
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @game = Game.create_game_for(@user1.id, [@user2, @user3])
    end
    it "sets the creator with the first turn" do
      expect(@game.gamemanager.player_turn).to eq Player.find_by(user_id: @user1.id).id
    end
    it "has the correct number of players" do
      expect(@game.players.size).to eq 3
    end
    it "returns the correct player list" do
      expect(@game.get_player_list).to include(@user1.name, @user2.name, @user3.name)
    end
    it "creates a valid supply card hash" do
      expect(@game.generate_supply_cards_hash).to be_a(Hash)
    end
    context "initializing player cards" do
      before :each do
        @game.initialize_player_cards
      end
      it "has created supply, hand, discard, played decks for plaeyrs" do 
        expect(@game.players.first.supply).to_not be_nil
        expect(@game.players.first.hand).to_not be_nil
        expect(@game.players.first.discard).to_not be_nil
        expect(@game.players.first.played).to_not be_nil
      end
      it "has drawn 5 cards for all players" do
        expect(@game.players.first.hand.cards.count).to eq 5
        expect(@game.players.second.hand.cards.count).to eq 5
        expect(@game.players.third.hand.cards.count).to eq 5
      end
    end
    after :all do
      DatabaseCleaner.clean_with(:truncation)
    end
  end

end
