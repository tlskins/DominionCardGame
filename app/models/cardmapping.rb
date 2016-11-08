class Cardmapping < ActiveRecord::Base
  has_many :cardlocations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :text, presence: true
  validates :cost, presence: true

  def Cardmapping.get(name)
    Cardmapping.find_by(name: name) ? Cardmapping.find_by(name: name).id : nil
  end

end
