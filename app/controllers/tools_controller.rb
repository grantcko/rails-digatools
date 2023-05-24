require 'streamio-ffmpeg'
EQ_DIRECTIONS = %i[radio highpass lowpass vocal]

class ToolsController < ApplicationController
  before_action :authenticate_user!
  def index
    @tools = current_user.tools
  end

  def show
    @tool = Tool.find(params[:id])
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

  # Get audio file and apply eq changes based on direction
  def equalize_audio(audio_input, direction)
    file_name = File.basename(audio_input.path)
    file_ext = file_name.match(/\.(?<extension>\w+)$/)[:extension]
    # append "_output" to the file
    output_file_name = "#{file_name}_output.#{file_ext}"
    # return error if invalid direction or audio_input
    raise ArgumentError.new("Invalid audio_input") unless valid_audio_input?(file_ext)
    raise ArgumentError.new("Invalid direction") unless valid_direction?(direction)
    # apply changes based on direction
    case direction
    when EQ_DIRECTIONS[0]
      # apply radio changes
      # audio_input()
      options = { audio_filter: 'equalizer=f=1000:t=h:width_type=h:width=200:g=10' }
      audio_input.transcode("storage/equalized_audio/#{output_file_name}", options)
    when EQ_DIRECTIONS[1]
      # apply highpass changes
    when EQ_DIRECTIONS[2]
      # apply lowpass changes
    when EQ_DIRECTIONS[3]
      # apply vocal changes
    end
    # return changed file with same file extension
  end

  private

  def tool_params
    params.require(:tool).permit(:name, :note, :internals, :links)
  end

  def valid_direction?(direction)
    return false if EQ_DIRECTIONS.exclude?(direction)

    return true
  end

  def valid_audio_input?(file_ext)
    valid_extensions = %w[wav aac mp3 m4a]
    return false if valid_extensions.exclude?(file_ext)

    return true
  end
end
