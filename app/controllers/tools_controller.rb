require 'faker'

class ToolsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:demo_show, :demo_index]
  skip_before_action :verify_authenticity_token

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

  def index
    @tools = current_user.tools
    @column_one = @tools.where(column: 1)
    @column_two = @tools.where(column: 2)
    @column_three = @tools.where(column: 3)
  end

  def demo_index
    tools = Tool::INTERNALS
    tools.delete('auto_equalizer')
    tools.delete('custom')
    @tools = tools
  end

  def show
    @tool = Tool.find(params[:id])
    @eq_directions = Tool::EQ_DIRECTIONS
    @photo_idea = random_photo_idea
  end

  def demo_show
    @eq_directions = Tool::EQ_DIRECTIONS
    @photo_idea = random_photo_idea
    @tool = params[:internal]
  end

  def new
    @tool = Tool.new
    @column = params[:col]
    @all_internals = Tool::INTERNALS
  end

  def create
    @tool = Tool.new(tool_params)
    @tool.user = current_user
    @tool.column = tool_params[:column]
    @tool.internals << tool_params[:internals]
    @tool.links << tool_params[:links]

    authorize @tool
    if @tool.save
      redirect_to @tool
    else
      redirect_to new_tool_path, status: :unprocessable_entity
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
    @tool = Tool.find(params[:id])
    authorize @tool
    @tool.destroy
  end

  private

  # returns a hash with the photo idea information
  def random_photo_idea
    noun = Faker::Appliance.equipment
    ideas = YAML.load_file(Rails.root.join('config', 'photo_ideas.yml'))
    random_idea = ideas['ideas'].sample
    idea_items = random_idea['items'].map { |item| item % { noun: } }
    idea_sentence = random_idea['idea'] % { noun: }
    return { idea_sentence:, idea_items: }
  end

  def tool_params
    params.require(:tool).permit(:name, :note, :internals, :links, :column)
  end
end
