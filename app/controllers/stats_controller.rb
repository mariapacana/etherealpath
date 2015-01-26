class StatsController < ApplicationController

  def index
    @missions = Mission.current
  end

end