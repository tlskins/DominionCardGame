require 'test_helper'

class GameTest < ActiveSupport::TestCase

  def setup
    @user1 = User.new(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user1.save
    @user2 = User.new(name: "Example User2", email: "user2@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user2.save
    @user3 = User.new(name: "Example User3", email: "user3@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user3.save
    @user4 = User.new(name: "Example User4", email: "user4@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user4.save
    @user5 = User.new(name: "Example User5", email: "user5@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user5.save
  end

  test "Create game, get player list, and end game" do
    # Create a new game
    game = Game.create_game_for([@user1, @user2, @user3, @user4, @user5])
    game.save
    assert_equal 5, game.players.count
    assert_equal "In Progress", game.status
    assert_match @user1.name, game.get_player_list
    assert_match @user2.name, game.get_player_list
    assert_match @user3.name, game.get_player_list
    assert_match @user4.name, game.get_player_list
    assert_match @user5.name, game.get_player_list
    # Check Gamemanager
    assert game.gamemanager
    assert_equal game.players.find_by(turn_order: 1).id.to_i, game.gamemanager.player_turn.to_i
    # End game
    game.end_game
    assert_equal "Finished", game.status
  end

end
