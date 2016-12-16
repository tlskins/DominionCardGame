require 'rails_helper'

RSpec.describe Deck, type: :model do

  describe "has valid factories" do
    it "has a valid default deck factory" do
      expect(build(:deck)).to be_valid
    end
    it "has a valid 3 card deck factory" do
      deck = create(:deck_three_cards)
      expect(deck.cards.count).to eq 3
    end
  end

  describe "has valid deck manipulation methods" do
    before :each do
      @deck1 = create(:deck)
    end

    context "one empty deck"
      context "add another deck with three cards to it" do
        before :each do
          @deck2 = create(:deck_three_cards)
          @card1 = get_bottom_card(@deck2)
          @card2 = get_middle_card(@deck2)
          @card3 = get_top_card(@deck2)
          @deck1.add_deck_to_top(@deck2)
          @deck1.reload
          @deck2.reload
        end
        it "maintains the correct deck size for the originally empty deck" do
          expect(@deck1.cards.size).to eq 3
        end
        it "maintains the correct deck size for the deck starting with 3 cards" do
          expect(@deck2.cards.size).to eq 0
        end
        it "maintains the correct card order for the first (bottom) card" do
          expect(@card1.card_order).to eq 1
        end
        it "maintains the correct card order for the second card" do
          expect(@card2.card_order).to eq 2
        end      
        it "maintains the correct card order for the third (top) card" do
          expect(@card3.card_order).to eq 3
        end
      end

      context "add a card to the top" do
        before :each do
          @deck1.add_card_to_top(create(:card))
        end
        it "maintains the correct deck size" do
          expect(@deck1.cards.size).to eq 1
        end
        it "has the correct card order" do
          expect(get_bottom_card(@deck1).card_order).to eq 1
        end
      end
    end

    context "one 3 card deck" do
      before :each do
        @deck1 = create(:deck_three_cards)
        @card1 = get_bottom_card(@deck1)
        @card2 = get_middle_card(@deck1)
        @card3 = get_top_card(@deck1)
      end
      context "add 3 card deck to this deck" do
        before :each do 
          @deck2 = create(:deck_three_cards)
          @card4 = get_bottom_card(@deck2)
          @card5 = get_middle_card(@deck2)
          @card6 = get_top_card(@deck2)
          @deck1.add_deck_to_top(@deck2)
          @deck1.reload
          @deck2.reload
        end
        it "maintains correct deck size" do
          expect(@deck1.cards.size).to eq 6
        end
        it "maintains the correct card order for the added deck cards" do
          expect(@card4.card_order).to eq 4
          expect(@card5.card_order).to eq 5
          expect(@card6.card_order).to eq 6
        end
        it "maintains the correct card order for the original deck" do
          expect(@card1.card_order).to eq 1 
          expect(@card2.card_order).to eq 2
          expect(@card3.card_order).to eq 3
        end
      end
    end

#    context "two 3 card decks"
#      it "maintains order when adding top card to top"
#      it "maintains order when adding middle card to top"
#      it "maintains order when adding bottom card to top"
#      it "maintains order when adding top card to bottom"
#      it "maintains order when adding middle card to bottom"
#      it "maintains order when adding bottom card to bottom"
#     end

end

