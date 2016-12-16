require 'rails_helper'

feature "Game behavior" do
  before :all do
    DatabaseCleaner.clean_with(:truncation)
    load "#{Rails.root}/db/seeds.rb"
  end

  scenario "start new 3 player game" do
    user1 = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    user4 = create(:user)
    user5 = create(:user)
    sign_in user1
    click_link "Games"

    expect(page).to have_link("New Game")
    click_link "New Game"

    # Add first opponent
    expect(page).to have_content("Create A New Game")
    expect(page).to have_content("Add Player")
    select user2.name, from: "Player"
    click_button "Add Player"

    # Add second opponent
    expect(page).to have_link(user2.name)
    expect(find(:css, 'select#player')).to have_content(user3.name)
    expect(find(:css, 'select#player')).to_not have_content(user2.name)
    select user3.name, from: "Player"
    click_button "Add Player"

    # Create game
    expect(page).to have_link(user3.name) 
    expect(find(:css, 'select#player')).to have_content(user4.name)
    expect(find(:css, 'select#player')).to_not have_content(user3.name)
    click_button "Create Game"

    # Validate game page
    expect(page).to have_content("New Game Started!")
    expect(page).to have_content("Player Turn: " + user1.name)
    expect(page).to have_button("End Action Phase")
  end

  scenario "game initialization behavior" do
    user1 = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    start_three_player_game(user1, user2, user3)
   
    # Validate game page
    expect(page).to have_content("New Game Started!")
    expect(page).to have_content("Player Turn: " + user1.name)
    expect(page).to have_content("Actions: 1")
    expect(page).to have_content("Buys: 1")
    expect(page).to have_button("End Action Phase")

    # End Action Phase begins Buy Phase

    # End Buy Phase begins Player2 Action phase

  end

  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end
end
