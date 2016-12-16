require 'rails_helper'

feature "Action Card Behavior" do
  before :all do
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
  end

  before :each do 
    @user1 = create(:user)
    @user2 = create(:user)
    @user3 = create(:user)
    start_three_player_game(@user1, @user2, @user3)
  end

  scenario "Village Card" do   
    # Convert first hand card to village
    convert_card_in_hand_to("Village")
    expect(find_card_in_deck('Village','hand')).to have_button('Play')
    find_card_in_deck('Village','hand').click_button('Play')

    # Validate +2 action / +1 card
    expect(page).to have_content('Actions: 2')
    expect_deck_card_count('hand', 5)
    expect_deck_card_count('played', 1)
    expect_card_info_button('End Action Phase')
    click_card_info_button('End Action Phase')

    # After End Action Phase
    expect_card_info_button('End Buy Phase')
    click_card_info_button('End Buy Phase')

    # After End Buy Phase
    expect(page).to_not have_content("Player Turn: " + @user1.name)
    expect(page).to have_content("Phase: Action")
    expect(page).to have_content("It's not your turn!")
  end

  scenario "Mine Card", js: true do
    # Convert first card to Mine
    convert_card_in_hand_to("Mine")
    convert_card_in_hand_to("Copper", 2)
    expect(find_card_in_deck("Mine", "hand")).to have_button("Play")
    expect_deck_single_card_count('hand','Copper',1)
    find_card_in_deck('Mine','hand').click_button('Play')

    # Validate Mine played
    expect(page).to have_content('Actions: 0')
    expect_deck_card_count('hand', 4)
    expect_deck_card_count('played', 1)
    expect_card_info_button('End Trash Phase')
    expect(find_card_in_deck('Copper', 'hand')).to have_button('Trash')  
    find_card_in_deck('Copper', 'hand').click_button('Trash')

    # Validate Silver trashed
    #expect_deck_card_count('hand', 3)
    #expect_card_info_button('End Gain Phase')
    #save_and_open_page
    expect(find_card_in_deck('Silver', 'supply')).to have_css('input[value=Gain]')
    find_card_in_deck('Silver', 'supply').click_button('Gain')
   
    # Validate Gold gained
    expect_deck_card_count('hand', 4)
    expect_deck_single_card_count('hand','Silver',1)
    expect_card_info_button('End Action Phase')
  end


  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end
end
