class CalibrelistsController < ApplicationController
  before_action :set_calibrelist, only: %i[ show edit update destroy ]

  # GET /calibrelists or /calibrelists.json
  def index
    @calibrelists = Calibrelist.all

    calibrelist = CalibrelistsHelper::Calibrelistx.new("Calibrelist", @calibrelists)
    respond_to do |format|
      format.html { render TblComponent.new(name: calibrelist.name, header: calibrelist.header, body: calibrelist.body) }
      format.json { render :show, status: :created, location: @calibrelist }
    end    
  end

  # GET /calibrelists/1 or /calibrelists/1.json
  def show
  end

  # GET /calibrelists/new
  def new
    @calibrelist = Calibrelist.new
  end

  # GET /calibrelists/1/edit
  def edit
  end

  # POST /calibrelists or /calibrelists.json
  def create
    @calibrelist = Calibrelist.new(calibrelist_params)

    respond_to do |format|
      if @calibrelist.save
        format.html { redirect_to calibrelist_url(@calibrelist), notice: "Calibrelist was successfully created." }
        format.json { render :show, status: :created, location: @calibrelist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @calibrelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calibrelists/1 or /calibrelists/1.json
  def update
    respond_to do |format|
      if @calibrelist.update(calibrelist_params)
        format.html { redirect_to calibrelist_url(@calibrelist), notice: "Calibrelist was successfully updated." }
        format.json { render :show, status: :ok, location: @calibrelist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @calibrelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calibrelists/1 or /calibrelists/1.json
  def destroy
    @calibrelist.destroy

    respond_to do |format|
      format.html { redirect_to calibrelists_url, notice: "Calibrelist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calibrelist
      @calibrelist = Calibrelist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calibrelist_params
      params.require(:calibrelist).permit(:xid, :xxid, :isbn, :zid, :uuid, :comments, :size, :series, :series_index, :title, :title_sort, :tags, :library_name, :formats, :timestamp, :pubdate, :publisher, :authors, :author_sort, :languages)
    end
end
