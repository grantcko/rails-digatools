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

  # send file from the filepath stored in the params
  def download
    output = params[:file]
    if File.file?("public/equalized_audio/#{output}")
      send_file "public/equalized_audio/#{output}", disposition: "attachment"
    else
      redirect_to tool_path(params[:id]), status: :unprocessable_entity
    end
  end

  # post request with audio and eq direction then apply equalization
  def equalize_audio
    # get direction and input from params
    direction = params[:direction].to_sym if params[:direction].present?
    input = params[:file] if params[:file].present?
    puts "# form data at `equalize_audio` in `tools_controller`:  #{input} #"

    # equalization logic - direction and input are good? then do:
    if direction && input && Tool.valid_direction?(direction) && Tool.valid_audio_input?(input)
      # equalize audio and return output(aka: filepath) -> delete after 5 minutes
      output = Tool.equalize(input, direction)
      RemoveFileJob.set(wait: 5.minutes).perform_later(output)
      return render json: { output: }
    else # redirect error 422
      redirect_to tool_path(params[:tool_id]), status: :unprocessable_entity
    end
  end

  def create
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

  def destroy
  end

  def generate_prompt
    put "# #{ params } #"
    return render json: { prompt: params[:prompt] }
  end

  private

  def tool_params
    params.require(:tool).permit(:name, :note, :internals, :links)
  end
end
