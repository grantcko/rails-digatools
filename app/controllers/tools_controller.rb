require 'streamio-ffmpeg'

class ToolsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  # after_action :remove_file, only: :download

  def index
    @tools = current_user.tools
  end

  def show
    @tool = Tool.find(params[:id])
    @eq_directions = Tool::EQ_DIRECTIONS
  end

  def download
    # send file from the filepath stored in the params
    output = params[:file]
    if File.file?("public/equalized_audio/#{output}")
      send_file "public/equalized_audio/#{output}", disposition: "attachment"
    else
      redirect_to tool_path(params[:id]), status: :unprocessable_entity
    end
  end

  def equalize_audio
    # => post request with audio and eq direction then apply equalization
    # get direction and input
    direction = params[:direction].to_sym if params[:direction].present?
    input = params[:file] if params[:file].present?
    puts "###################\n#{input}"

    #### EQUALIZATION LOGIC:
    if direction && input && Tool.valid_direction?(direction) && Tool.valid_audio_input?(input)
      # equalize audio and return output - delete after 5 minutes
      output = Tool.equalize(input, direction)
      RemoveFileJob.set(wait: 5.minutes).perform_later(output)
      return render json: { output: }
    else
      # redirect 422 if the direction or input doesn't exist or is invalid
      redirect_to tool_path(params[:tool_id]), status: :unprocessable_entity
    end
  end

  def create
    # create a new instance of a tool
    @tool = Tool.new(tool_params)

    if @tool.save
      redirect_to @tool
    else
      status :unprocessable_entity
      render 'tool'
    end
  end

  def update
    # update and instance of a tool
    @tool = Tool.find(params[:id])
    if @tool.update(tool_params)
      redirect_to @tool
    else
      status :unprocessable_entity
      render 'edit'
    end
  end

  private

  def tool_params
    params.require(:tool).permit(:name, :note, :internals, :links)
  end
end
