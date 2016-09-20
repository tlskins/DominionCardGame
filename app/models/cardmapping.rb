class Cardmapping < ActiveRecord::Base
  has_many :cardlocations
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :text, presence: true
  validates :cost, presence: true
end
