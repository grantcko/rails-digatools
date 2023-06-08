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
    # /download => downloads file from filepath stored in the params
    output = params[:file]
    raise
    if File.file?(output)
      send_file "public/equalized_audio/#{output}", disposition: "attachment"
    else
      redirect_to tool_path(params[:tool_id]), status: "file does not exist"
    end
  end

  def equalize_audio
    # get direction and input
    direction = params[:direction].to_sym if params[:direction].present?
    input = params[:file] if params[:file].present?

    # equalize audio and return output if valid
    if direction && input && Tool.valid_direction?(direction) && Tool.valid_audio_input?(input)
      output = Tool.equalize(input, direction)
      RemoveFileJob.set(wait: 5.minutes).perform_later(output)
      return render json: { output: }
    else
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

  # def remove_file
  #   `rm public/equalized_audio/#{params[:file]}`
  # end
end
