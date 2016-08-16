require 'test_helper'

class CardTest < ActiveSupport::TestCase

  def setup
    @Cardmapping = Cardmapping.new(name: "Test Card Mapping Name", text: "Test Card Mapping Text", cost: 0)
    @Cardmapping.save
    @Card = Card.new(cardmapping_id: @Cardmapping.id)
    @Card.save
  end

  test "Card returns correct values from mapping" do
    assert_equal @Card.name, @Cardmapping.name
    assert_equal @Card.text, @Cardmapping.text
    assert_equal @Card.is_action, @Cardmapping.is_action
    assert_equal @Card.is_attack, @Cardmapping.is_attack
    assert_equal @Card.is_reaction, @Cardmapping.is_reaction
    assert_equal @Card.is_treasure, @Cardmapping.is_treasure
    assert_equal @Card.is_victory, @Cardmapping.is_victory
    assert_equal @Card.treasure_amount, @Cardmapping.treasure_amount
    assert_equal @Card.victory_points, @Cardmapping.victory_points
    assert_equal @Card.cost, @Cardmapping.cost
  end


end
