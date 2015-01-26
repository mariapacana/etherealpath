class StatsController < ApplicationController

  def index
    @missions = Mission.all
  end

end