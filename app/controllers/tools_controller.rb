require 'streamio-ffmpeg'
EQ_DIRECTIONS = %i[highpass radio lowpass vocal]

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
    # define file name and extension then append "_output" to the file
    file_name = File.basename(audio_input)
    file_ext = file_name.match(/\.(?<extension>\w+)$/)[:extension]
    output_file_name = "#{file_name}_output.#{file_ext}"

    # return error if invalid direction or audio_input
    raise ArgumentError.new("Invalid audio_input") unless valid_audio_input?(file_ext)
    raise ArgumentError.new("Invalid direction") unless valid_direction?(direction)

    # apply eq changes based on direction
    case direction
    when EQ_DIRECTIONS[0] # highpass
      # apply HIGHPASS changes with ffmpeg cli (both channels, at 0Hz, 3000Hz wide, -96dB )
      system("ffmpeg -i #{audio_input} -af 'anequalizer=c0 f=0 w=3000 g=-96 t=2|c1 f=0 w=3000 g=-96 t=2' storage/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[1] # radio
      # apply RADIO changes with ffmpeg cli (both channels, at Hz, Hz wide, -dB )
      system("ffmpeg -i #{audio_input} -af 'anequalizer=c0 f=0 w=2500 g=-96 t=2|c1 f=0 w=2500 g=-96 t=2|c0 f=15000 w=16000 g=-96 t=2|c1 f=15000 w=16000 g=-96 t=2' storage/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[2] # lowpass
      # apply lowpass changes
      system("ffmpeg -i #{audio_input} -af 'anequalizer=c0 f=15000 w=16000 g=-96 t=2|c1 f=15000 w=16000 g=-96 t=2' storage/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[3] # vocal
      # apply vocal changes
      system("ffmpeg -i #{audio_input} -af 'anequalizer=c0 f=3000 w=2000 g=10 t=2|c1 f=3000 w=2000 g=10 t=2' storage/equalized_audio/#{output_file_name}")
    end
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
