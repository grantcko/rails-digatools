require 'streamio-ffmpeg'
EQ_DIRECTIONS = %i[highpass radio lowpass vocal]

class ToolsController < ApplicationController
  before_action :authenticate_user!
  def index
    @tools = current_user.tools
  end

  def show
    @tool = Tool.find(params[:id])
    @eq_directions = EQ_DIRECTIONS

    if params[:direction].present?
      @select_eq_direction = params[:direction]
    end

    if params[:file].present?
      @select_audio_input = params[:file]
    end

    if @select_eq_direction && @select_audio_input
      equalize_audio(@select_audio_input, @select_eq_direction.to_sym)
    end
  end

  def download
    output_path = params[:file]
    send_file "public/equalized_audio/#{output_path}", disposition: "attachment"
  end

  def equalize_audio(audio_input, direction)
    Tool.equalize(audio_input, direction)
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
