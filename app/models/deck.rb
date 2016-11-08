class Deck < ActiveRecord::Base
  has_many :cards
  accepts_nested_attributes_for :cards

  # Returns true if there are 0 cards in this deck
  def empty?
    if cards.nil?
      return true
    else
      if cards.size == 0
        return true
      end
      return false
    end
  end

  # Adds all the cards in a deck to this deck
  def add_deck_to_top(add_deck)
    if add_deck.cards and add_deck.id != self.id and add_deck.cards.size > 0
      orig_count = self.cards.size
      add_deck.cards.each do |c|
        c.update_attributes(deck_id: id, card_order: (c.card_order + orig_count))
      end
    end
  end

  # Adds the given card to the top of the deck
  def add_card_to_top(card)
    unless self.id.nil? or (card.deck_id == self.id and card.card_order == get_top_order)
      #Update order of card's current deck
      if card.deck_id
        card.deck.cards.where("card_order > ?", card.card_order).each do |r|
          r.update_attributes(card_order: (r.card_order-1) )
        end
      end
      # Add the card to the top of the new deck
      card.update_attributes(deck_id: id, card_order: (get_top_order+1) )
    end
  end

  # Adds the given card to the bottom of the deck
  def add_card_to_bottom(card)
    unless self.id.nil? or (card.deck_id == self.id and card.card_order == 1)
      # Decrese the orders for the cards above in the old deck
      if card.deck_id
        card.deck.cards.where("card_order > ?", card.card_order).each do |r|
          r.update_attributes(card_order: (r.card_order-1) )
        end
      end
      # Increase the orders for cards above in the new deck
      cards.each do |r|
        r.update_attributes(card_order: (r.card_order+1) )
      end
      # Add the card to the bottom of the new deck
      card.update_attributes(deck_id: id, card_order: 1)
    end
  end

  # Returns the card at the top of the deck
  def return_cards_from_top(count)
    if cards and count > 0
      cards.where("card_order > ?", (get_top_order-count) )
    end
  end

  # Shuffle the order of the cards in the deck
  def shuffle
    shuffled_order = cards.pluck('card_order').shuffle
    counter = 0
    cards.each do |r|
      r.update_attribute(:card_order, shuffled_order[counter])
      counter += 1
    end
  end

  # Returns the order number of the card at the top of the deck or 0 if none
  def get_top_order
    cards.maximum('card_order') || 0
  end    
 
  # Returns an array of all the treasure cards in the current deck
  def all_treasure_cards
    treasure_cards = []
    cards.each do |c|
      if c.cardmapping.is_treasure == true 
        treasure_cards << c 
      end
    end
    return treasure_cards
  end
end
