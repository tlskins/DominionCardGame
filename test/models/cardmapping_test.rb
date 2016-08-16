require 'test_helper'

class CardmappingTest < ActiveSupport::TestCase
  def setup
    @Cardmapping = Cardmapping.new(name: "Test Card Mapping Name", text: "Test Card Mapping Text", cost: 0)
  end

  test "Card mappings should be unique" do
    duplicate_mapping = @Cardmapping.dup
    duplicate_mapping.name = @Cardmapping.name.upcase
    @Cardmapping.save
    assert_not duplicate_mapping.valid?
  end
end
