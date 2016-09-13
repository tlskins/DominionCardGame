require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar")
    @user.save
    @player = Player.new(user_id: @user.id)
  end

  test "Player returns correct values from user" do
    assert @player.valid?
    @player.save
    assert_equal @user.name, @player.name
  end


end
