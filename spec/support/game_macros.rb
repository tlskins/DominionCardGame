module GameMacros

  # Logs in a test user using CRUD commands for controller testing
  def log_in_as(user, is_feature = false, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if is_feature
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  # Signs in a test user for RSpec feature testing
  def start_three_player_game(user1, user2, user3)
    sign_in user1
    click_link "Games"
    click_link "New Game"
    select user2.name, from: "Player"
    click_button "Add Player"
    select user3.name, from: "Player"
    click_button "Add Player"
    click_button "Create Game"
  end

  # Converts a card in player's hand to a desired card
  def convert_card_in_hand_to(card_name, card_order = 1)
    new_mapping_id = Cardmapping.get(card_name)
    player = Game.last.gamemanager.current_player
    #player.hand.cards.first.update_attributes(cardmapping_id: new_mapping_id) if (player and new_mapping_id)
    update_card = player.hand.cards.find_by(card_order: card_order)
    update_card.update_attributes(cardmapping_id: new_mapping_id) if (player and new_mapping_id and update_card)
    visit current_path
  end

  # Expects the given deck to have the given card count
  def expect_deck_card_count(deck_name, card_count)
    expect(find('div[class=' + deck_name + '_cards]')).to have_css('div[class=card_treasure], div[class=card_action], div[class=card_victory]', :count => card_count)
  end

  # Expects the given deck should have the given card for the given count
  def expect_deck_single_card_count(deck_name, card_name, card_count)
    expect(find('div[class=' + deck_name + '_cards]')).to have_css('div[data-name=' + card_name + ']', :count => card_count)
  end

  def expect_card_info_button(button_text)
    expect(find('div[class=card_info]')).to have_css('input[value="' + button_text + '"]')
  end

  # Finds the deck div with the passed name
  def find_section(deck_name)
    find('div[class=' + deck_name + ']')
  end

  # Locates a give card in a given deck
  def find_card_in_deck(card_name, deck_name)
    find('div[class=' + deck_name + '_cards]').find('div[data-name=' + card_name + ']')
  end

  def click_card_info_button(button_name)
    find('div[class=card_info]').click_button(button_name)
  end

end



