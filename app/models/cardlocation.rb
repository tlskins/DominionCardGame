class Cardlocation < ActiveRecord::Base
  belongs_to :card
  belongs_to :deck
  belongs_to :cardmapping
  before_save :check_order


  private

    # Update order to max of deck if order is null
    def check_order
      if card_order.nil? and deck
        update_attributes(card_order: deck.get_top_order + 1)
      end
    end  

end
