class Cardmapping < ActiveRecord::Base
  has_many :cardlocations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :text, presence: true
  validates :cost, presence: true
  validates :treasure_amount, presence: true, if: "is_treasure"
  validates :victory_points, presence: true, if: "is_victory"


  def Cardmapping.get(name)
    Cardmapping.find_by(name: name) ? Cardmapping.find_by(name: name).id : nil
  end

end
