require 'rails_helper'

RSpec.describe Gamemanager, type: :model do
  it "has a valid factory" do
    expect(build(:gamemanager)).to be_valid
  end
  it "sets values to 0 in default factory" do
    expect(build(:gamemanager).actions).to eq 0
    expect(build(:gamemanager).treasure).to eq 0
    expect(build(:gamemanager).buys).to eq 0
    expect(build(:gamemanager).phase).to eq 'Action'
  end

  describe "correct behavior" do
    before :all do
      DatabaseCleaner.clean_with(:truncation)
      load "#{Rails.root}/db/seeds.rb"
      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      @game = Game.create_game_for(@user1.id, [@user2, @user3])
      @player1 = Player.find_by(user_id: @user1.id, game_id: @game.id)
      @game.initialize_player_cards
    end
    it "initializes with the correct phase" do
      expect(@game.gamemanager.phase).to eq 'Action'
    end
    it "current treasure balance accurately calculates balance" do
      balance = 0
      @player1.hand.cards.each do |c|
        if c.cardmapping.is_treasure
          balance = balance + c.cardmapping.treasure_amount
        end
      end
      expect(@game.gamemanager.current_treasure_balance).to eq balance
    end
    it "updates the current phase and updates to the correct phase" do
      @game.gamemanager.next_phase
      expect(@game.gamemanager.phase).to eq 'Buy'
    end
    it "buy card moves card from supply to discard and decrements supply count" do
      card_name = @game.generate_supply_cards_hash.keys.first
      card_count = @game.generate_supply_cards_hash['Copper']['count']
      @game.gamemanager.buy_card(card_name)
      expect(@player1.discard.cards.first.cardmapping.name).to eq 'Copper'
      expect(@game.generate_supply_cards_hash['Copper']['count']).to eq 14
    end
    after :all do
      DatabaseCleaner.clean_with(:truncation)
    end
  end
end
