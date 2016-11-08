require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def setup
    Rails.application.load_seed
    @user1 = User.new(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user1.save
    @user2 = User.new(name: "Example User2", email: "user2@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user2.save
    @game = Game.create_game_for([@user1, @user2])
    @game.initialize_player_cards
  end

  test "Player names" do
    assert @game.players.first.name
  end

  test "Draw Card and Play Card location logic" do
    a = @game.players.first

    # Return hand cards to deck to satisfy testing start condition of deck / hand
    while a.hand.cards.reload.size > 0 do
      a.return_to_supply_top_card(a.hand.cards.reload.first)
    end
    while a.supply.cards.reload.size > 10 do
      a.add_to_trash( a.supply.cards.first )
    end
 
    assert_equal 10, a.supply.cards.reload.size
    assert_equal 0, a.hand.cards.reload.size

    a.draw_card(1)
    assert_equal 9, a.supply.cards.reload.size
    assert_equal 1, a.hand.cards.reload.size

    a.play_card(a.hand.reload.cards.first)
    assert_equal 9, a.supply.cards.reload.size
    assert_equal 0, a.hand.cards.reload.size
    assert_equal 1, a.discard.cards.reload.size

    a.draw_card(3)
    assert_equal 6, a.supply.cards.reload.size
    assert_equal 3, a.hand.cards.reload.size
    assert_equal 1, a.discard.cards.reload.size

    a.play_card(a.hand.reload.cards.first)
    a.play_card(a.hand.reload.cards.first)
    assert_equal 6, a.supply.cards.reload.size
    assert_equal 1, a.hand.cards.reload.size
    assert_equal 3, a.discard.cards.reload.size

    a.draw_card(7)
    assert_equal 2, a.supply.reload.cards.reload.size
    assert_equal 8, a.hand.reload.cards.reload.size
    assert_equal 0, a.discard.reload.cards.reload.size

    # Play a card in the supply, verify no change
    # puts 'name of supply first = ' + a.supply.reload.cards.first.name.to_s
    a.play_card(a.supply.reload.cards.reload.first)
    assert_equal 2, a.supply.cards.reload.size
    assert_equal 8, a.hand.cards.reload.size
    assert_equal 0, a.discard.cards.reload.size

    # Draw more cards than available in supply and discard
    a.draw_card(3)
    assert_equal 0, a.supply.cards.reload.size
    assert_equal 10, a.hand.cards.reload.size
    assert_equal 0, a.discard.cards.reload.size

    a.play_card(a.hand.reload.cards.first)
    a.play_card(a.hand.reload.cards.first)
    assert_equal 0, a.supply.cards.reload.size
    assert_equal 8, a.hand.cards.reload.size
    assert_equal 2, a.discard.cards.reload.size

    a.draw_card(2)
    assert_equal 0, a.supply.cards.reload.size
    assert_equal 10, a.hand.cards.reload.size
    assert_equal 0, a.discard.cards.reload.size

  end


end
