require "rails_helper"

feature "creating new missions" do
  background do
    @user = User.create({first_name: "Bob",
                        last_name: "Hob",
                        email: "bob@hob.com",
                        password: "bobbob",
                        password_confirmation: "bobbob"})
    @mission = Mission.create({title: "Awesome Mission",
                               description: "Weird Time",
                               intro: "You have a choice",
                               warning: "Be very afraid",
                               decline_confirmation: "OK fine",
                               finish_confirmation: "Congrats",
                               location_invite: "rooted, SF, or Ebay?",
                               completed_challenges_required: 3,
                               start_time: DateTime.new(2020,1,1)})
    @challenge1 = @mission.challenges.create({location: "SF",
                                            question: "blah",
                                            response_success: "blah",
                                            response_failure: "blah",
                                            any_answer_acceptable: false})
    @answer1 = @challenge1.answers.create({text: "OK"})
  end

  scenario "logged-in user can create a new mission" do
    page.set_rack_session(:user_id => @user.id)
    page.visit "/missions/#{@mission.id}"
    expect(page).to have_selector("h1", text: @mission.title)
    expect(page).to have_selector("li p", text: @mission.start_time)
    expect(page).to have_selector("li p", text: @mission.description)
    expect(page).to have_selector("li p", text: @mission.intro)
    expect(page).to have_selector("li p", text: @mission.warning)
    expect(page).to have_selector("li p", text: @mission.decline_confirmation)
    expect(page).to have_selector("li p", text: @mission.finish_confirmation)
    expect(page).to have_selector("li p", text: @mission.location_invite)
    expect(page).to have_selector("li p", text: @mission.completed_challenges_required)
    expect(page).to have_selector("h3", text: "Challenges")
    expect(page).to have_selector("li p", text: @challenge1.question)
    expect(page).to have_selector("li p", text: @challenge1.response_success)
    expect(page).to have_selector("li p", text: @challenge1.response_failure)
    expect(page).to have_selector("li p", text: @challenge1.any_answer_acceptable)
    expect(page).to have_selector("li b", text: "Answers")
    expect(page).to have_selector("li ul li p", text: @answer1.text)
    expect(page).to have_selector("li ul li p", text: @answer1.text)
  end

  scenario "logged-in user can create hand-of-god message" do
    page.set_rack_session(:user_id => @user.id)
    page.visit "/missions/#{@mission.id}"
    fill_in('Ethereal Message', :with => 'I am the Lord')
    select('East Bay', :from => 'Location')
    expect(page).to have_content('I am the Lord')
  end
end