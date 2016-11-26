require 'rails_helper'

RSpec.feature "User", :type => :feature do
  scenario "Create a new user" do
    count = User.count
    visit "/users/new"

    fill_in "Name", :with => "My Name2"
    fill_in "Email", :with => "my2@email.com"
    fill_in "Password", :with => "123456789"
    fill_in "Confirmation", :with => "123456789"

    click_button "Create my account"

    expect(page).to have_text("My Name")
    expect(User.count).to eq(count + 1)
  end
end
