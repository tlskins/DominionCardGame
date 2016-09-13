require 'test_helper'

class GamemanagerTest < ActiveSupport::TestCase
  
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
    @game = Game.create_game_for([@user1, @user2, @user3])
    @game.save
  end

  test "End Phase and End Turn" do
    assert @game.gamemanager
    # First Player
    assert_equal 'Preaction', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 1).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Action', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 1).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Buy', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 1).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    # Second Player
    assert_equal 'Preaction', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 2).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Action', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 2).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Buy', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 2).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    # Third Player
    assert_equal 'Preaction', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 3).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Action', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 3).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Buy', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 3).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    # Back to first player
    assert_equal 'Preaction', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 1).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Action', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 1).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
    assert_equal 'Buy', @game.gamemanager.phase
    assert_equal @game.players.find_by(turn_order: 1).id.to_i, @game.gamemanager.player_turn.to_i
    @game.gamemanager.next_phase
  end

end
