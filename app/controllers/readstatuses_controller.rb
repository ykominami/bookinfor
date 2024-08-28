class ReadstatusesController < ApplicationController
  before_action :set_readstatus, only: %i[ show edit update destroy ]

  # GET /readstatuses or /readstatuses.json
  def index
    @readstatuses = Readstatus.all
  end

  # GET /readstatuses/1 or /readstatuses/1.json
  def show
  end

  # GET /readstatuses/new
  def new
    @readstatus = Readstatus.new
  end

  # GET /readstatuses/1/edit
  def edit
  end

  # POST /readstatuses or /readstatuses.json
  def create
    @readstatus = Readstatus.new(readstatus_params)

    respond_to do |format|
      if @readstatus.save
        format.html { redirect_to readstatus_url(@readstatus), notice: "Readstatus was successfully created." }
        format.json { render :show, status: :created, location: @readstatus }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @readstatus.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /readstatuses/1 or /readstatuses/1.json
  def update
    respond_to do |format|
      if @readstatus.update(readstatus_params)
        format.html { redirect_to readstatus_url(@readstatus), notice: "Readstatus was successfully updated." }
        format.json { render :show, status: :ok, location: @readstatus }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @readstatus.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /readstatuses/1 or /readstatuses/1.json
  def destroy
    @readstatus.destroy!

    respond_to do |format|
      format.html { redirect_to readstatuses_url, notice: "Readstatus was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_readstatus
      @readstatus = Readstatus.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def readstatus_params
      params.require(:readstatus).permit(:name)
    end
end
