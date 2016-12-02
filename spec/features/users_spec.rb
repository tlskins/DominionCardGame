require 'rails_helper'

feature "User management" do
  scenario "Create a new user" do
    count = User.count
    visit signup_path

    fill_in "Name", :with => "My Name2"
    fill_in "Email", :with => "my2@email.com"
    fill_in "Password", :with => "123456789"
    fill_in "Confirmation", :with => "123456789"

    click_button "Create my account"

    expect(page).to have_content("My Name")
    expect(User.count).to eq(count + 1)
  end

  scenario "Update user" do
    user = create(:user)
    sign_in user

    expect(page).to have_content user.name
    click_link "Settings"
   
    expect(page).to have_content("Update your profile")
    fill_in "Name", :with => "Dynamite"
    click_button "Save changes"

    expect(page).to have_content("Profile updated")
    expect(page).to have_content("Dynamite") 
  end

  scenario "Visit user and user index" do
    user1 = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    sign_in user1
    click_link "Users"

    expect(page).to have_content("All users")
    expect(page).to have_content(user1.name)
    expect(page).to have_content(user2.name)
    expect(page).to have_content(user3.name) 
    expect(page).to_not have_content("delete")
    click_link user2.name

    expect(page).to have_content(user2.name)   
  end

  scenario "Admin user delete existing user" do
    admin = create(:user_admin)
    user1 = create(:user)
    user2 = create(:user)
    user3 = create(:user)
    sign_in admin
    click_link "Users"
    expect(page).to have_content(user1.name)
    within("li", :text => user1.name) do |ref|
      click_link "delete"
    end

    expect(page).to have_content("User deleted")
    click_link "Users"

    expect(page).to_not have_content(user1.name)
    expect(page).to have_content(user2.name)
    expect(page).to have_content(user3.name)
  end
end

