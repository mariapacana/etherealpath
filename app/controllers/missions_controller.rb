class MissionsController < ApplicationController

  def mission_params
    answers = {:answers_attributes => [:id,
                                       :text,
                                       :_destroy]}
    params.require(:mission).permit(:title,
                                    :description,
                                    :start_time,
                                    challenges_attributes: [:id,
                                                            :location,
                                                            :question,
                                                            answers,
                                                            :response_success,
                                                            :response_failure,
                                                            :_destroy])
  end

  def new
    @mission = Mission.new
  end

  def create
    #TODO: Extract into a helper
    s_time_params = ["start_time(1i)",
                   "start_time(2i)",
                   "start_time(3i)",
                   "start_time(4i)",
                   "start_time(5i)"]

    start_time = DateTime.new(*s_time_params.map {|p| mission_params[p].to_i})
    new_mission_params = mission_params.except(*s_time_params).merge({start_time: start_time})

    @mission = Mission.new(mission_params)
    if @mission.save
      redirect_to mission_path(@mission)
    else
      # show error message if mission is invalid
      render :new
    end
  end

  def show
    @mission = Mission.find(params[:id])
  end

  def edit
    @mission = Mission.find(params[:id])
  end

  def update
    @mission = Mission.find(params[:id])
    if @mission.update_attributes(mission_params)
      redirect_to mission_path(@mission)
    else
      # show error message if mission is invalid
      flash[:error] = @mission.errors.full_messages
      render :edit
    end
  end

  def index
    @missions = Mission.all()
  end
end