require "spec_helper"

feature "user sign up" do
	scenario "when a new user signs up, the user count increases by 1" do
		visit "/"
		click_button "sign up"
		expect(page.status_code).to eq 200
		fill_in :user_name, with: 'Andrew'
		fill_in :email_address, with: 'cool_dude_89@hotmail.com'
		fill_in :password, with: 'Passw0rd'
    click_button "create user"
		expect(User.count).to eq(1)
    within "div.welcome"do
      expect(page).to have_content "Welcome Andrew"
    end
	end
end
