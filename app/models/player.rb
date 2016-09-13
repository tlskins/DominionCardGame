class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  has_one :supply, class_name: "Deck", foreign_key: "game_id", dependent: :destroy
  has_one :hand, class_name: "Deck", foreign_key: "game_id", dependent: :destroy
  has_one :discard, class_name: "Deck", foreign_key: "game_id", dependent: :destroy

    def name
      self.user.name
    end

end
