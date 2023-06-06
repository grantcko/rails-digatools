require 'streamio-ffmpeg'

class ToolsController < ApplicationController
  before_action :authenticate_user!
  def index
    @tools = current_user.tools
  end

  def show
    @tool = Tool.find(params[:id])
    @eq_directions = Tool::EQ_DIRECTIONS
  end

  def download
    # /download => downloads file from filepath stored in the params
    output_path = params[:file]
    send_file "public/equalized_audio/#{output_path}", disposition: "attachment"
  end

  def equalize_audio
    # get direction and input
    direction = params[:direction].to_sym if params[:direction].present?
    input = params[:file] if params[:file].present?

    # equalize audio and return output if valid
    if direction && input && Tool.valid_direction?(direction) && Tool.valid_audio_input?(input)
      return Tool.equalize(input, direction)
      # output = Tool.equalize(input, direction)
      # redirect_to "/download?file=#{output}"
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
end
