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
    @select_eq_direction = params[:direction]
    @select_audio_input = params[:file]
    if !@select_eq_direction.nil? || !@select_audio_input.nil?
      @output = equalize_audio(@select_audio_input, @select_eq_direction.to_sym)
      full_path = "#{Rails.root}/#{@output}"
      send_file full_path, type: 'audio/wav'
      # raise
      # erase file
      system("rm #{full_path}")
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

  # Get audio file and apply eq changes based on direction
  def equalize_audio(audio_input, direction)
    # define file name as the path of the input unless input is a string
    if audio_input.is_a?(String)
      file_name = audio_input
    else
      file_name = audio_input.path
    end

    # define basename and file extension
    file_base_name = File.basename(audio_input)
    file_ext = file_base_name.match(/\.(?<extension>\w+)$/)[:extension]

    # append "_output" to the file
    output_file_name = "#{file_base_name}_output.#{file_ext}"

    # return error if invalid direction or audio_input
    raise ArgumentError.new("Invalid audio_input") unless valid_audio_input?(file_ext)
    raise ArgumentError.new("Invalid direction") unless valid_direction?(direction)
    # apply eq changes based on direction
    case direction
    when EQ_DIRECTIONS[0] # highpass
      # apply HIGHPASS changes with ffmpeg cli (both channels, at 0Hz, 3000Hz wide, -96dB )
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=0 w=3000 g=-96 t=2|c1 f=0 w=3000 g=-96 t=2' public/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[1] # radio
      # apply RADIO changes with ffmpeg cli (both channels, at Hz, Hz wide, -dB )
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=0 w=2500 g=-96 t=2|c1 f=0 w=2500 g=-96 t=2|c0 f=15000 w=16000 g=-96 t=2|c1 f=15000 w=16000 g=-96 t=2' public/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[2] # lowpass
      # apply lowpass changes
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=15000 w=16000 g=-96 t=2|c1 f=15000 w=16000 g=-96 t=2' public/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[3] # vocal
      # apply vocal changes
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=3000 w=2000 g=10 t=2|c1 f=3000 w=2000 g=10 t=2' public/equalized_audio/#{output_file_name}")
    end
    return "public/equalized_audio/#{output_file_name}"
  end

  # def download(file_path)
  #   full_path = "#{Rails.root}/#{file_path}"
  #   # raise unless send_file(full_path)
  # end

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
