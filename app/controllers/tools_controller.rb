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

  private

  def tool_params
    params.require(:tool).permit(:name, :note, :internals, :links)
  end
end
