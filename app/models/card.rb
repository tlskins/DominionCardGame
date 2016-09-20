class Card < ActiveRecord::Base
  #has_one :cardlocation
  has_one :mapping, through: :cardlocation

  def name
    self.mapping.name
  end

  def text
    self.mapping.text
  end

  def is_action
    self.mapping.is_action
  end

  def is_attack
    self.mapping.is_attack
  end

  def is_reaction
    self.mapping.is_reaction
  end

  def is_treasure
    self.mapping.is_treasure
  end

  def is_victory
    self.mapping.is_victory
  end

  def treasure_amount
    self.mapping.treasure_amount
  end

  def victory_points
    self.mapping.victory_points
  end

  def cost
    self.mapping.cost
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

  # Plays this card
  #def play_card(gamecontroller)
  #  self.send(name + '(gamecontroller)') if self.respond_to(name, true)
  #end 

  #private

    # Village: +1 card / +2 actions
    #def village(gamecontroller)
    #  puts 'Village called!'
    #end

end
