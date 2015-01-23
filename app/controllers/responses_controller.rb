class ResponsesController < ApplicationController

  def download_picture
    @response = Response.find(params[:id])
    redirect_to @response.picture.expiring_url(10)
  end

end