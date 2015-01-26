require 'csv'

class MissionsController < ApplicationController

  def mission_params
    answers = {:answers_attributes => [:id,
                                       :text,
                                       :_destroy]}
    params.require(:mission).permit(:title,
                                    :description,
                                    :start_time,
                                    :intro,
                                    :current,
                                    :warning,
                                    :decline_confirmation,
                                    :finish_confirmation,
                                    :location_invite,
                                    :completed_challenges_required,
                                    challenges_attributes: [:id,
                                                            :location,
                                                            :question,
                                                            :any_answer_acceptable,
                                                            :needs_pic,
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
    new_mission_params = mission_params.except(*s_time_params).merge({start_time: start_time, current: true})

    @mission = Mission.new(mission_params)
    if @mission.save
      redirect_to mission_path(@mission)
    else
      # show error message if mission is invalid
      render :new
    end
  end

  def add_participants
    @modelized_participants = []
    @participants = CSV.read(params["Participant"].tempfile, headers: true, skip_blanks: true)
    @participants.each do |p|
      @modelized_participant = Participant.new({first_name: p['first_name'],last_name: p['last_name'], email: p['email']})
      @modelized_participant.update_attribute(:code, p['code']) if p['code']
      @modelized_participant.update_attribute(:mission, Mission.last)
      if @modelized_participant.save
        @modelized_participant.phone_numbers.create({number: p['phone_number'],
                                                     preferred: true})
      end
      @modelized_participants << @modelized_participant
    end
    redirect_to root_path
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