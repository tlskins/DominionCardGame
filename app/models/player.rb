class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_one :supply, -> { where "status = 'Supply'" }, class_name: 'Deck'
  has_one :hand, -> { where "status = 'Hand'" }, class_name: 'Deck'
  has_one :discard, -> { where "status = 'Discard'" }, class_name: 'Deck'

    def name
      self.user.name
    end

end
