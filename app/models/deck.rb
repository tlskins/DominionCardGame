class Deck < ActiveRecord::Base
  has_many :card_relationships, class_name: "Cardlocation", foreign_key: "deck_id"
  has_many :cards, through: :card_relationships, source: :card

  # Adds the given card to the top of the deck
  def add_card_to_top(card)
    unless self.id.nil? or (card.deck == self.id and card.order == get_top_order)
      #Update order of card's current deck
      if card.deck
        Deck.find(card.cardlocation.deck_id).card_relationships.where("card_order > ?", card.order).each do |r|
          r.update_attributes(card_order: (r.card_order-1) )
        end
      end
      # Add the card to the top of the new deck
      if card.cardlocation
        card.cardlocation.update_attributes(deck_id: id, card_order: (get_top_order+1) )
      else
        card.create_cardlocation(deck_id: id, card_order: (get_top_order+1) )
      end
    end
  end

  # Adds the given card to the bottom of the deck
  def add_card_to_bottom(card)
    unless self.id.nil? or (card.deck == self.id and card.order == 1)
      # Decrese the orders for the cards above in the old deck
      if card.deck
        Deck.find(card.cardlocation.deck_id).card_relationships.where("card_order > ?", card.order).each do |r|
          r.update_attributes(card_order: (r.card_order-1) )
        end
      end
      # Increase the orders for cards above in the new deck
      card_relationships.all.each do |r|
        r.update_attributes(card_order: (r.card_order+1) )
      end
      # Add the card to the bottom of the new deck
      if card.cardlocation
        card.cardlocation.update_attributes(deck_id: id, card_order: 1)
      else
        card.create_cardlocation(deck_id: id, card_order: 1)
      end
    end
  end


  # Returns the card at the top of the deck
  def draw_card
    if cards
      cards.find( card_relationships.find_by(card_order: get_top_order).card_id )
    end
  end

  # Shuffle the order of the cards in the deck
  def shuffle
    shuffled_order = card_relationships.pluck('card_order').shuffle
    counter = 0
    card_relationships.each do |r|
      r.update_attribute(:card_order, shuffled_order[counter])
      counter += 1
    end
  end

  # Returns the order number of the card at the top of the deck or 0 if none
  def get_top_order
    card_relationships.maximum('card_order') || 0
  end    
end
