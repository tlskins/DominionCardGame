class Cardlocation < ActiveRecord::Base
  belongs_to :card
  belongs_to :deck
  validates :card_id, presence: true, uniqueness: true
  validates :card_order, presence: true
  validates :deck_id, presence: true
end
