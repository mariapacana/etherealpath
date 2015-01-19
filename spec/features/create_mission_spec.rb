require "rails_helper"

feature "creating new missions", :js => true do
  background do
    @user = User.create({first_name: "Bob",
                        last_name: "Hob",
                        email: "bob@hob.com",
                        password: "bobbob",
                        password_confirmation: "bobbob"})
  end

  scenario "logged-in user can create a new mission" do
    page.set_rack_session(:user_id => @user.id)
    page.visit '/missions/new'

    expect(page).to have_content 'Create a New Mission'

    fill_in('Title', :with => 'Awesome Mission')

    select '2015', :from => 'mission_start_time_1i'
    select 'January', :from => 'mission_start_time_2i'
    select '30', :from => 'mission_start_time_3i'
    select '12', :from => 'mission_start_time_4i'
    select '00', :from => 'mission_start_time_5i'

    fill_in('Description', :with => 'Best Ever')
    fill_in('Intro', :with => "Text 'Yes' to begin your initiation.")
    fill_in('Warning', :with => "Text 'Angel' to have your burden lifted")
    fill_in('Decline Confirmation', :with => 'OK Fine')
    fill_in('Finish Confirmation', :with => 'Congrats')
    fill_in('Location Invite', :with => 'Rooted, SF, or East Bay?')
    fill_in('Challenges Required to Complete', :with => '3')

    click_link('add challenge')
    select('East Bay', :from => 'Location')
    fill_in('Question', :with => 'Best Ever')
    fill_in('Response on Success', :with => 'Congrats')
    fill_in('Response on Failure', :with => 'Boo')
    find("input[type='checkbox']").set(true)
    click_link('add answer')
    fill_in('Answer', :with => 'Correct Answer')
    click_button 'Create Mission'
    expect(page).to have_selector("h1", text: 'Awesome Mission')
  end

end