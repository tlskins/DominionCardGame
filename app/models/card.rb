class Card < ActiveRecord::Base
  belongs_to :cardmapping
  belongs_to :deck
  before_save :check_order

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

  # Mark the card as selectable
  def mark_selectable
    update_attributes(selectable: true)
  end

  # Mark the card as un-selectable
  def unmark_selectable
    update_attributes(selectable: false)
  end


  # Return the div class to be used for this card for CSS purposes
  def div_class
    unless self.cardmapping.nil?
      if self.cardmapping.is_action or self.cardmapping.is_attack or self.cardmapping.is_reaction
        return 'card_action'
      elsif self.cardmapping.is_treasure
        return 'card_treasure'
      elsif self.cardmapping.is_victory
        return 'card_victory'
      else
        return 'card'
      end
    end
  end

    private

      # Update order to max of deck if order is null
      def check_order
        if card_order.nil? and deck_id
          update_attributes(card_order: (deck.get_top_order+1) )
        end
      end

end
