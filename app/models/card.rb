class Card < ActiveRecord::Base
  belongs_to :cardmapping
  has_one :cardlocation

  def name
    self.cardmapping.name
  end

  def text
    self.cardmapping.text
  end

  def is_action
    self.cardmapping.is_action
  end

  def is_attack
    self.cardmapping.is_attack
  end

  def is_reaction
    self.cardmapping.is_reaction
  end

  def is_treasure
    self.cardmapping.is_treasure
  end

  def is_victory
    self.cardmapping.is_victory
  end

  def treasure_amount
    self.cardmapping.treasure_amount
  end

  def victory_points
    self.cardmapping.victory_points
  end

  def cost
    self.cardmapping.cost
  end

  # Returns the current order of this card
  def order
   if cardlocation
    self.cardlocation.card_order
   end
  end

  # Returns the deck_id that the card is currently in
  def deck
    if cardlocation
      Deck.find(cardlocation.deck_id).id
    end
  end

end
