class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_one :supply, -> { where "status = 'Supply'" }, class_name: 'Deck'
  has_one :hand, -> { where "status = 'Hand'" }, class_name: 'Deck'
  has_one :discard, -> { where "status = 'Discard'" }, class_name: 'Deck'
  has_one :played, -> { where "status = 'Played'" }, class_name: 'Deck'

  # Returns the user name
  def name
    return user.name
  end

  # Draw given number of cards to hand from supply
  def draw_card(count)
    if supply and discard and count > 0
      extra_draws = count-supply.cards.size
      # Draw cards from supply
      supply.cards.where('card_order > ?', (supply.cards.size-count)).each do |c|
        hand.add_card_to_top(c)
      end
      # Recycle discard if necessary
      if extra_draws > 0
        recycle_discard
        #puts 'after recycle supply size = ' + supply.cards.reload.size.to_s + ' discard size = ' + discard.cards.reload.size.to_s + ' extra draws = ' + extra_draws.to_s
        # Draw remaining cards from reycled supply
        supply.cards.reload.where('card_order > ?', (supply.cards.size-extra_draws)).each do |c|
          hand.add_card_to_top(c)
        end
      end
    end
  end

  # Put the given card to the top of your supply
  def add_to_supply(card)
    self.supply.add_card_to_top(card) unless supply.nil?
  end

  # Put the given card to the top of your hand
  def add_to_hand(card)
    self.hand.add_card_to_top(card) unless hand.nil?
  end

  # Puts the given cards at the top of the trash deck
  def add_to_trash(card)
    game.trash.add_card_to_top(card) unless game.trash.nil?
  end

  # Puts the given card at the top of the discard deck
  def add_to_discard(card)
    discard.add_card_to_top(card) unless discard.nil?
  end

  # Puts the given card at the top of the played deck
  def add_to_played(card)
    played.add_card_to_top(card) unless played.nil?
  end

  # Plays a given card from the hand
  def play_card(card)
    if hand.cards.where('id = ?', card.id).exists?
      discard.add_card_to_top(card)
    end
  end

  # Puts a given card from the hand to the top of the deck
  def return_to_supply_top_card(card)
    if hand.cards.where('id = ?', card.id).exists?
      supply.add_card_to_top(card)
    end
  end

  # Mark all the cards in your hand as selectable
  def mark_all_hand_selectable
    hand.cards.all.each do |c|
      c.mark_selectable
    end
  end

  # Mark all the cards in your hand as not-selectable
  def unmark_all_hand_selectable
    hand.cards.all.each do |c|
      c.unmark_selectable
    end
  end


  # Mark the cards in your hand, all with the given type, as not-selectable
  def mark_hand_type_selectable(type)
    hand.cards.all.each do |c|
      c.mark_selectable if (type == 'Action' and c.is_action)
      c.mark_selectable if (type == 'Attack' and c.is_attack)
      c.mark_selectable if (type == 'Reaction' and c.is_reaction)
      c.mark_selectable if (type == 'Treasure' and c.is_treasure)
      c.mark_selectable if (type == 'Victory' and c.is_victory)
    end
  end


    private

    # Puts discarded cards back into your supply and shuffle
    def recycle_discard
      #puts 'recycle_discard called! supply size = ' + supply.cards.reload.size.to_s + ' discard size = ' + discard.cards.reload.size.to_s
      if supply.cards.reload.size == 0
        supply.add_deck_to_top(discard)
        supply.shuffle
      end
    end
end
