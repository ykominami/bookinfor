class ReadinglistsController < ApplicationController
  before_action :set_readinglist, only: %i[ show edit update destroy ]

  # GET /readinglists or /readinglists.json
  def index
    @readinglists = Readinglist.all

    readinglist = ReadinglistsHelper::Reainglistx.new("Readinglist", @readinglists)
    respond_to do |format|
      format.html { render TblComponent.new(name: readinglist.name, header: readinglist.header, body: readinglist.body) }
      format.json { render :show, status: :created, location: @kindlelist }
    end    
  end

  # GET /readinglists/1 or /readinglists/1.json
  def show
  end

  # GET /readinglists/new
  def new
    @readinglist = Readinglist.new
  end

  # GET /readinglists/1/edit
  def edit
  end

  # POST /readinglists or /readinglists.json
  def create
    @readinglist = Readinglist.new(readinglist_params)

    respond_to do |format|
      if @readinglist.save
        format.html { redirect_to readinglist_url(@readinglist), notice: "Readinglist was successfully created." }
        format.json { render :show, status: :created, location: @readinglist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @readinglist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /readinglists/1 or /readinglists/1.json
  def update
    respond_to do |format|
      if @readinglist.update(readinglist_params)
        format.html { redirect_to readinglist_url(@readinglist), notice: "Readinglist was successfully updated." }
        format.json { render :show, status: :ok, location: @readinglist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @readinglist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /readinglists/1 or /readinglists/1.json
  def destroy
    @readinglist.destroy

    respond_to do |format|
      format.html { redirect_to readinglists_url, notice: "Readinglist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_readinglist
      @readinglist = Readinglist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def readinglist_params
      params.require(:readinglist).permit(:register_date, :date, :title, :status, :shape, :isbn)
    end
end
