class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %I[home]

  def home
  end
end
