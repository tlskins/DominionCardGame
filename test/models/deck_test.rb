require 'test_helper'

class DeckTest < ActiveSupport::TestCase

  def setup
    @Mapping_copper = cardmappings(:copper)
    @Mapping_estate = cardmappings(:estate)
    @Mapping_copper.save
    @Mapping_estate.save
    @Card_copper = Card.new(cardmapping_id: @Mapping_copper.id)
    @Card_estate = Card.new(cardmapping_id: @Mapping_estate.id)
    @Card_copper2 = Card.new(cardmapping_id: @Mapping_copper.id)
    @Card_estate2 = Card.new(cardmapping_id: @Mapping_estate.id)
    @Deck_one = Deck.new
    @Deck_two = Deck.new
  end

  test "Add card to bottom of deck - two decks" do
    # Test when deck and cards are not saved to db
    @Deck_one.add_card_to_bottom(@Card_copper)
    assert_not @Card_copper.deck

    @Card_copper.save
    @Card_estate.save
    @Card_copper2.save
    @Card_estate2.save
    @Deck_one.save
    @Deck_two.save

    @Deck_one.add_card_to_bottom(@Card_copper)
    assert_equal @Deck_one.id, @Card_copper.deck
    assert_equal 1, @Card_copper.reload.order

    @Deck_one.add_card_to_bottom(@Card_estate)
    assert_equal @Deck_one.id, @Card_estate.deck
    assert_equal @Deck_one.id, @Card_copper.deck
    assert_equal 1, @Card_estate.reload.order
    assert_equal 2, @Card_copper.reload.order

    @Deck_one.add_card_to_bottom(@Card_copper2)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_copper.deck, @Deck_one.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal 1, @Card_copper2.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 3, @Card_copper.reload.order

    @Deck_one.add_card_to_bottom(@Card_estate2)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_copper.deck, @Deck_one.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_one.id
    assert_equal 3, @Card_estate.reload.order
    assert_equal 4, @Card_copper.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_bottom(@Card_estate)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_one.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_one.id
    assert_equal 1, @Card_estate.reload.order
    assert_equal 3, @Card_copper.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_bottom(@Card_copper)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_one.id
    assert_equal 2, @Card_estate.reload.order
    assert_equal 1, @Card_copper.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_bottom(@Card_estate2)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_two.id
    assert_equal 3, @Card_estate.reload.order
    assert_equal 2, @Card_copper.reload.order
    assert_equal 1, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_bottom(@Card_copper2)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_two.id
    assert_equal @Card_estate2.deck, @Deck_two.id
    assert_equal 4, @Card_estate.reload.order
    assert_equal 3, @Card_copper.reload.order
    assert_equal 1, @Card_copper2.reload.order
    assert_equal 2, @Card_estate2.reload.order
  end


  test "Shuffle deck" do
    @Card_copper.save
    @Card_copper2.save
    @Card_estate.save
    @Card_estate2.save
    @Deck_one.save
    @Deck_two.save

    @Deck_one.add_card_to_top(@Card_copper)
    @Deck_one.add_card_to_top(@Card_estate)
    @Deck_one.add_card_to_top(@Card_copper2)
    #print 'card orders before shuffle then add card - (w 4 cards)' + @Deck_one.card_relationships.reload.pluck('card_order').to_s
    @Deck_one.reload.shuffle
    @Deck_one.add_card_to_top(@Card_estate2)
    assert_equal 4, @Deck_one.card_relationships.reload.pluck('card_order').uniq.count
    #print 'card orders after shuffle then add card - (w 4 cards)' + @Deck_one.card_relationships.reload.pluck('card_order').to_s
    
    @Card_copper3 = @Card_copper2.dup
    @Card_copper3.save
    @Deck_one.add_card_to_top(@Card_copper3)
    #print 'card orders before add card then shuffle (w 5 cards) - ' + @Deck_one.card_relationships.reload.pluck('card_order').to_s
    @Deck_one.reload.shuffle
    assert_equal 5, @Deck_one.card_relationships.reload.pluck('card_order').uniq.count
    #print 'card orders after add card then shuffle (w 5 cards)- ' + @Deck_one.card_relationships.reload.pluck('card_order').to_s
  end


  test "Draw card" do
    @Card_copper.save
    @Card_copper2.save
    @Card_estate.save
    @Card_estate2.save
    @Deck_one.save
    @Deck_two.save

    @Deck_one.add_card_to_top(@Card_copper)
    @Deck_one.add_card_to_top(@Card_estate)
    @Deck_one.add_card_to_top(@Card_copper2)
    @Deck_one.add_card_to_top(@Card_estate2)

    assert_equal @Deck_one.draw_card.id, @Card_estate2.id

    @Deck_two.add_card_to_top( @Deck_one.draw_card )
    assert_equal @Deck_one.id, @Card_copper.reload.deck
    assert_equal @Deck_one.id, @Card_estate.reload.deck
    assert_equal @Deck_one.id, @Card_copper2.reload.deck
    assert_equal @Deck_two.id, @Card_estate2.reload.deck
    assert_equal 1, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 3, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_top( @Deck_one.draw_card )
    assert_equal @Deck_one.id, @Card_copper.reload.deck
    assert_equal @Deck_one.id, @Card_estate.reload.deck
    assert_equal @Deck_two.id, @Card_copper2.reload.deck
    assert_equal @Deck_two.id, @Card_estate2.reload.deck
    assert_equal 1, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_top( @Deck_one.draw_card )
    assert_equal @Deck_one.id, @Card_copper.reload.deck
    assert_equal @Deck_two.id, @Card_estate.reload.deck
    assert_equal @Deck_two.id, @Card_copper2.reload.deck
    assert_equal @Deck_two.id, @Card_estate2.reload.deck
    assert_equal 1, @Card_copper.reload.order
    assert_equal 3, @Card_estate.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    @Deck_two.add_card_to_top( @Deck_one.draw_card )
    assert_equal @Deck_two.id, @Card_copper.reload.deck
    assert_equal @Deck_two.id, @Card_estate.reload.deck
    assert_equal @Deck_two.id, @Card_copper2.reload.deck
    assert_equal @Deck_two.id, @Card_estate2.reload.deck
    assert_equal 4, @Card_copper.reload.order
    assert_equal 3, @Card_estate.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order
  end

  test "Add card to top of deck - one deck" do
    # Test when deck and cards are not saved to db
    @Deck_one.add_card_to_top(@Card_copper)
    assert_not @Card_copper.deck 
   
    @Card_copper.save
    @Card_estate.save
    @Deck_one.save

    @Deck_one.add_card_to_top(@Card_copper)
    assert_equal @Card_copper.deck, @Deck_one.id

    @Deck_one.add_card_to_top(@Card_estate)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal 2, @Card_estate.reload.order
    assert_equal 1, @Card_copper.reload.order

    @Deck_one.add_card_to_top(@Card_copper)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal 1, @Card_estate.reload.order
    assert_equal 2, @Card_copper.reload.order

    @Deck_one.add_card_to_top(@Card_copper)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal 1, @Card_estate.reload.order
    assert_equal 2, @Card_copper.reload.order
  end

  test "Add card to top of deck - two decks" do
    # Test when deck and cards are not saved to db
    @Card_copper.save
    @Card_copper2.save
    @Card_estate.save
    @Card_estate2.save
    @Deck_one.save
    @Deck_two.save

    @Deck_one.add_card_to_top(@Card_copper)
    @Deck_one.add_card_to_top(@Card_estate)
    @Deck_one.add_card_to_top(@Card_copper2)
    @Deck_one.add_card_to_top(@Card_estate2)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_copper.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_one.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal 1, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 3, @Card_copper2.reload.order
    assert_equal 4, @Card_estate2.reload.order    

    # Add card from other deck top
    @Deck_two.add_card_to_top(@Card_estate2)
    assert_equal @Card_estate.deck, @Deck_one.id
    assert_equal @Card_copper.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal 1, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 3, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    # Add card from other deck middle
    @Deck_two.add_card_to_top(@Card_estate)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_one.id
    assert_equal @Card_estate2.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal 1, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 2, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    # Add card from other deck bottom
    @Deck_two.add_card_to_top(@Card_copper)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_two.id
    assert_equal @Card_estate2.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_one.id
    assert_equal 3, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 1, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order

    # Add last card in other deck
    @Deck_two.add_card_to_top(@Card_copper2)
    assert_equal @Card_estate.deck, @Deck_two.id
    assert_equal @Card_copper.deck, @Deck_two.id
    assert_equal @Card_estate2.deck, @Deck_two.id
    assert_equal @Card_copper2.deck, @Deck_two.id
    assert_equal 3, @Card_copper.reload.order
    assert_equal 2, @Card_estate.reload.order
    assert_equal 4, @Card_copper2.reload.order
    assert_equal 1, @Card_estate2.reload.order
  end


end
