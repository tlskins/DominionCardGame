require 'test_helper'

class DeckTest < ActiveSupport::TestCase

  def setup
    Rails.application.load_seed
    #@Mapping_copper =Cardmapping.get('Copper')
    #@Mapping_estate = Cardmapping.get('Estate')
    #@Mapping_copper.save
    #@Mapping_estate.save
    @Deck_one = Deck.create
    @Deck_two = Deck.create
    @Card_copper = Card.new(cardmapping_id: Cardmapping.get('Copper')) 
    @Card_estate = Card.new(cardmapping_id: Cardmapping.get('Estate')) 
    @Card_copper2 = Card.new(cardmapping_id: Cardmapping.get('Copper'))
    @Card_estate2 = Card.new(cardmapping_id: Cardmapping.get('Estate')) 
    @Card_copper3 = Card.new(cardmapping_id: Cardmapping.get('Copper'))
  end

  test "Test Add Deck to Top" do
    #puts 'begin test add deck to top'
    assert @Card_copper.save
    assert @Card_estate.save
    assert @Card_copper2.save
    assert @Card_estate2.save
    @Deck_one.add_card_to_bottom(@Card_copper)
    @Deck_one.reload.add_card_to_bottom(@Card_estate)
    @Deck_two.add_card_to_bottom(@Card_copper2)
    assert_equal 2, @Deck_one.cards.reload.size
    assert_equal 1, @Deck_two.cards.reload.size
    assert_equal 1, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper.reload.card_order
    @Deck_two.add_deck_to_top(@Deck_one.reload)
    assert_equal 3, @Deck_two.cards.reload.size
    assert_equal 0, @Deck_one.cards.reload.size
    assert_equal 1, @Card_copper2.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper.reload.card_order
    @Deck_one.reload.add_deck_to_top(@Deck_two.reload)
    assert_equal 3, @Deck_one.cards.reload.size
    assert_equal 0, @Deck_two.cards.reload.size
    assert_equal 1, @Card_copper2.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper.reload.card_order
  end

  test "Add card to bottom of deck - two decks" do
    # Test when deck and cards are not saved to db

    @Card_copper.save
    @Card_estate.save
    @Card_copper2.save
    @Card_estate2.save

    @Deck_one.add_card_to_bottom(@Card_copper)
    assert_equal @Deck_one.id, @Card_copper.deck_id
    assert_equal 1, @Card_copper.card_order
    assert_equal 1, @Deck_one.reload.cards.size

    @Deck_one.add_card_to_bottom(@Card_estate)
    assert_equal @Deck_one.id, @Card_estate.deck_id
    assert_equal @Deck_one.id, @Card_copper.deck_id
    assert_equal 2, @Deck_one.reload.cards.size
    assert_equal 1, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper.reload.card_order

    @Deck_one.add_card_to_bottom(@Card_copper2)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_copper.deck_id, @Deck_one.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal 3, @Deck_one.reload.cards.size
    assert_equal 1, @Card_copper2.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper.reload.card_order

    @Deck_one.add_card_to_bottom(@Card_estate2)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_copper.deck_id, @Deck_one.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_one.id
    assert_equal 4, @Deck_one.reload.cards.size
    assert_equal 3, @Card_estate.reload.card_order
    assert_equal 4, @Card_copper.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_bottom(@Card_estate)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_one.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_one.id
    assert_equal 1, @Deck_two.reload.cards.size
    assert_equal 3, @Deck_one.reload.cards.size
    assert_equal 1, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_bottom(@Card_copper)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_one.id
    assert_equal 2, @Deck_two.reload.cards.size
    assert_equal 2, @Deck_one.reload.cards.size
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_bottom(@Card_estate2)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_two.id
    assert_equal 3, @Deck_two.reload.cards.size
    assert_equal 1, @Deck_one.reload.cards.size
    assert_equal 3, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper.reload.card_order
    assert_equal 1, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_bottom(@Card_copper2)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_two.id
    assert_equal @Card_estate2.deck_id, @Deck_two.id
    assert_equal 4, @Deck_two.reload.cards.size
    assert_equal 0, @Deck_one.reload.cards.size
    assert_equal 4, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper.reload.card_order
    assert_equal 1, @Card_copper2.reload.card_order
    assert_equal 2, @Card_estate2.reload.card_order
  end


  test "Shuffle deck" do
    @Card_copper.save
    @Card_copper2.save
    @Card_estate.save
    @Card_estate2.save
    @Card_copper3.save

    @Deck_one.add_card_to_top(@Card_copper)
    @Deck_one.add_card_to_top(@Card_estate)
    @Deck_one.add_card_to_top(@Card_copper2)
    #print 'card orders before shuffle then add card - (w 4 cards)' + @Deck_one.card_relationships.reload.pluck('card_order').to_s
    @Deck_one.reload.shuffle
    @Deck_one.add_card_to_top(@Card_estate2)
    assert_equal 4, @Deck_one.cards.reload.pluck('card_order').uniq.count
    #print 'card orders after shuffle then add card - (w 4 cards)' + @Deck_one.cards.reload.pluck('card_order').to_s
    @Deck_one.add_card_to_top(@Card_copper3)
    #print 'card orders before add card then shuffle (w 5 cards) - ' + @Deck_one.cards.reload.pluck('card_order').to_s
    @Deck_one.reload.shuffle
    assert_equal 5, @Deck_one.cards.reload.pluck('card_order').uniq.count
    #print 'card orders after add card then shuffle (w 5 cards)- ' + @Deck_one.cards.reload.pluck('card_order').to_s
  end


  test "Draw card" do
    @Card_copper.save
    @Card_copper2.save
    @Card_estate.save
    @Card_estate2.save

    @Deck_one.add_card_to_top(@Card_copper)
    @Deck_one.add_card_to_top(@Card_estate)
    @Deck_one.add_card_to_top(@Card_copper2)
    @Deck_one.add_card_to_top(@Card_estate2)

    #puts '@Deck_one.return_cards_from_top(1).first.card_order = ' + @Deck_one.return_cards_from_top(1).first.card_order.to_s
    assert_equal @Deck_one.return_cards_from_top(1).first.id, @Card_estate2.id

    @Deck_two.add_card_to_top( @Deck_one.return_cards_from_top(1).first )
    assert_equal @Deck_one.id, @Card_copper.reload.deck_id
    assert_equal @Deck_one.id, @Card_estate.reload.deck_id
    assert_equal @Deck_one.id, @Card_copper2.reload.deck_id
    assert_equal @Deck_two.id, @Card_estate2.reload.deck_id
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_top( @Deck_one.return_cards_from_top(1).first )
    assert_equal @Deck_one.id, @Card_copper.reload.deck_id
    assert_equal @Deck_one.id, @Card_estate.reload.deck_id
    assert_equal @Deck_two.id, @Card_copper2.reload.deck_id
    assert_equal @Deck_two.id, @Card_estate2.reload.deck_id
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_top( @Deck_one.return_cards_from_top(1).first )
    assert_equal @Deck_one.id, @Card_copper.reload.deck_id
    assert_equal @Deck_two.id, @Card_estate.reload.deck_id
    assert_equal @Deck_two.id, @Card_copper2.reload.deck_id
    assert_equal @Deck_two.id, @Card_estate2.reload.deck_id
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 3, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    @Deck_two.add_card_to_top( @Deck_one.return_cards_from_top(1).first )
    assert_equal @Deck_two.id, @Card_copper.reload.deck_id
    assert_equal @Deck_two.id, @Card_estate.reload.deck_id
    assert_equal @Deck_two.id, @Card_copper2.reload.deck_id
    assert_equal @Deck_two.id, @Card_estate2.reload.deck_id
    assert_equal 4, @Card_copper.reload.card_order
    assert_equal 3, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order
  end

  test "Add card to top of deck - one deck" do
    @Card_copper.save
    @Card_estate.save

    @Deck_one.add_card_to_top(@Card_copper)
    assert_equal @Card_copper.deck_id, @Deck_one.id

    @Deck_one.add_card_to_top(@Card_estate)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 1, @Card_copper.reload.card_order

    @Deck_one.add_card_to_top(@Card_copper)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal 1, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper.reload.card_order

    @Deck_one.add_card_to_top(@Card_copper)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal 1, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper.reload.card_order
  end

  test "Add card to top of deck - two decks" do
    # Test when deck and cards are not saved to db
    @Card_copper.save
    @Card_copper2.save
    @Card_estate.save
    @Card_estate2.save

    @Deck_one.add_card_to_top(@Card_copper)
    @Deck_one.add_card_to_top(@Card_estate)
    @Deck_one.add_card_to_top(@Card_copper2)
    @Deck_one.add_card_to_top(@Card_estate2)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_copper.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_one.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper2.reload.card_order
    assert_equal 4, @Card_estate2.reload.card_order    

    # Add card from other deck top
    @Deck_two.add_card_to_top(@Card_estate2)
    assert_equal @Card_estate.deck_id, @Deck_one.id
    assert_equal @Card_copper.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 3, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    # Add card from other deck middle
    @Deck_two.add_card_to_top(@Card_estate)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_one.id
    assert_equal @Card_estate2.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal 1, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 2, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    # Add card from other deck bottom
    @Deck_two.add_card_to_top(@Card_copper)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_two.id
    assert_equal @Card_estate2.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_one.id
    assert_equal 3, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 1, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order

    # Add last card in other deck
    @Deck_two.add_card_to_top(@Card_copper2)
    assert_equal @Card_estate.deck_id, @Deck_two.id
    assert_equal @Card_copper.deck_id, @Deck_two.id
    assert_equal @Card_estate2.deck_id, @Deck_two.id
    assert_equal @Card_copper2.deck_id, @Deck_two.id
    assert_equal 3, @Card_copper.reload.card_order
    assert_equal 2, @Card_estate.reload.card_order
    assert_equal 4, @Card_copper2.reload.card_order
    assert_equal 1, @Card_estate2.reload.card_order
  end


end
