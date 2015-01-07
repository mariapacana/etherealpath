class TwilioController < ApplicationController
  def index
    puts params
    # find user in database, according to phone
    # if user doesn't exist, ask for the passcode
    # put users through challenges
  end
end