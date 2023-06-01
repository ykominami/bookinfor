class KindlelistsController < ApplicationController
  before_action :set_kindlelist, only: %i[ show edit update destroy ]

  # GET /kindlelists or /kindlelists.json
  def index
    # kindlelists = Kindlelist.where("read_status != ?", 4)
    kindlelists = Kindlelist.all
    @kindlelists = kindlelists

    kindlelist = KindlelistsHelper::Kindlelistx.new("Kindlelist", @kindlelists)
    respond_to do |format|
      format.html { render TblComponent.new(name: kindlelist.name, header: kindlelist.header, body: kindlelist.body) }
      format.json { render :show, status: :created, location: @kindlelist }
    end    
  end

  # GET /kindlelists/1 or /kindlelists/1.json
  def show
  end

  # GET /kindlelists/new
  def new
    @kindlelist = Kindlelist.new
  end

  # GET /kindlelists/1/edit
  def edit
  end

  # POST /kindlelists or /kindlelists.json
  def create
    @kindlelist = Kindlelist.new(kindlelist_params)

    respond_to do |format|
      if @kindlelist.save
        format.html { redirect_to kindlelist_url(@kindlelist), notice: "Kindlelist was successfully created." }
        format.json { render :show, status: :created, location: @kindlelist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @kindlelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kindlelists/1 or /kindlelists/1.json
  def update
    respond_to do |format|
      if @kindlelist.update(kindlelist_params)
        format.html { redirect_to kindlelist_url(@kindlelist), notice: "Kindlelist was successfully updated." }
        format.json { render :show, status: :ok, location: @kindlelist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @kindlelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /kindlelists/1 or /kindlelists/1.json
  def destroy
    @kindlelist.destroy

    respond_to do |format|
      format.html { redirect_to kindlelists_url, notice: "Kindlelist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kindlelist
      @kindlelist = Kindlelist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kindlelist_params
      params.require(:kindlelist).permit(:asin, :title, :publisher, :author, :publish_date, :purchase_date)
    end
end
