class HomeController < ApplicationController
  # GET /home or /home.json
  def index
    @abcs = Abc.all
  end

  # GET /home/1 or /home/1.json
  def show; end
end
