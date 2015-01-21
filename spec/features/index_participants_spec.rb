require "rails_helper"

feature "showing help", :js => true do
  background do
    @user = User.create({first_name: "Bob",
                        last_name: "Hob",
                        email: "bob@hob.com",
                        password: "bobbob",
                        password_confirmation: "bobbob"})
    @participant1 = Participant.create({first_name: "RJD2",
                                       last_name: "D2",
                                       needs_help: true})
    @participant2 = Participant.create({first_name: "WE2",
                                       last_name: "D2",
                                       needs_help: true})
    @participant1.messages.create({text: "angel",
                                   incoming: true})
    @participant2.messages.create({text: "angel",
                                   incoming: true})
  end

  scenario "all the users seeking help are listed" do
    page.set_rack_session(:user_id => @user.id)
    page.visit '/help'

    expect(page).to have_selector("h1", text: "Help Desk")
    expect(page).to have_selector("li a", text: "RJD2 D2")
    expect(page).to have_selector("li p", text: "angel")

    click_link('RJD2 D2')
    expect(page).to have_selector("h1", text: 'Messages')
  end

end