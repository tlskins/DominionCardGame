module DeckMacros

  # Returns the bottom card of a deck
  def get_bottom_card(deck)
    deck.cards.each do |c|
      return c if c.card_order == 1
    end
  end

  # Returns the middle card of the deck
  def get_middle_card(deck)
    if deck.cards.size == 0
      return nil
    elsif deck.cards.size == 1
      return deck.cards.first
    elsif deck.cards.size > 1
      deck.cards.each do |c|
        return c if c.card_order == (deck.cards.size/2.to_f).ceil
      end
    end
  end

  # Returns the top card of the deck
  def get_top_card(deck)
    deck.cards.each do |c|
      return c if c.card_order == deck.get_top_order
    end
  end
end
