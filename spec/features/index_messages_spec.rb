require "rails_helper"

feature "showing message history", :js => true do
  background do
    @user = User.create({first_name: "Bob",
                        last_name: "Hob",
                        email: "bob@hob.com",
                        password: "bobbob",
                        password_confirmation: "bobbob"})
    @participant1 = Participant.create({first_name: "RJD2",
                                       last_name: "D2",
                                       needs_help: true})
    @participant1.phone_numbers.create({number: "+16502008405"})
    @participant1.messages.create({text: "angel",
                                   incoming: true})
    @participant1.messages.create({text: "yes",
                                   incoming: false})
    @participant1.messages.create({text: "sigh",
                                   incoming: true})
  end

  scenario "showing message history" do
    page.set_rack_session(:user_id => @user.id)
    page.visit "/participants/#{@participant1.id}/messages"
    expect(page).to have_selector("h1", text: "Messages with RJD2 D2")

    expect(page).to have_content("Ethereal Help Desk Message")

    expect(page).to have_selector("li p", text: "angel")
    expect(page).to have_selector("li b", text: "yes")
    expect(page).to have_selector("li p", text: "sigh")
  end

  scenario "creating a new ethereal message" do
    page.set_rack_session(:user_id => @user.id)
    page.visit "/participants/#{@participant1.id}/messages"
    fill_in('Ethereal Help Desk Message', :with => 'Amazing Message')
    click_button 'Create Message'
    expect(page).to have_selector("li b", text: "Amazing Message")
  end

  scenario "unflagging a participant" do
    page.set_rack_session(:user_id => @user.id)
    page.visit "/participants/#{@participant1.id}/messages"
    expect(page).to have_css('.help_button_active')
    click_button 'Unflag'
    expect(page).to have_css('.help_button_inactive')
  end
end