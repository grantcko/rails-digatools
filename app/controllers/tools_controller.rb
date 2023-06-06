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
    direction = params[:direction].to_sym if params[:direction].present?
    input = params[:file] if params[:file].present?

    if direction && input && Tool.valid_direction?(direction) && Tool.valid_audio_input?(input)
      Tool.equalize(input, direction)
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
