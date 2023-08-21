class KindlelistsController < ApplicationController
  before_action :set_kindlelist, only: %i[ show edit update destroy ]

  # GET /kindlelists or /kindlelists.json
  def index
    @search = Kindlelist.ransack(params[:q])
    @search.sorts = "purchase_date desc" if @search.sorts.empty?
    @kindlelists = @search.result.page(params[:page])
    @new_kindlelist = Kindlelist.new
    # p @kindlelists
    @readstatus_list = ReadstatusesHelper::get_list()
    @category_list = CategoriesHelper::get_list()

    # kindlelists = Kindlelist.where("read_status != ?", 4)
    # kindlelists = Kindlelist.limit(2)
    # kindlelists = Kindlelist.all
    # @kindlelists = kindlelists

    respond_to do |format|
      format.html { }
      format.json { render :show, status: :created, location: @kindlelist }
    end
  end

  # GET /kindlelists/1 or /kindlelists/1.json
  def show
  end

  # GET /kindlelists/new
  def new
    @kindlelist = Kindlelist.new
    @readstatus_list = ReadstatusesHelper::get_list()
    @category_list = CategoriesHelper::get_list()
  end

  # GET /kindlelists/1/edit
  def edit
    @readstatus_list = ReadstatusesHelper::get_list()
    @category_list = CategoriesHelper::get_list()
  end

  # POST /kindlelists or /kindlelists.json
  def create
    @kindlelist = Kindlelist.new(kindlelist_params)

    respond_to do |format|
      ret = false
      begin
        ret = @kindlelist.save
      rescue => exception
        p exception.message
      end
      if ret
        format.html { render }
        format.turbo_stream { render }
        format.json { render :show, status: :created, location: @kindlelist }
      else
        @readstatus_list = ReadstatusesHelper::get_list()
        @category_list = CategoriesHelper::get_list()
        p "create ret=#{ret} 2"
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @kindlelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /kindlelists/1 or /kindlelists/1.json
  def update
    respond_to do |format|
      if @kindlelist.update(kindlelist_params)
        format.html { }
        format.turbo_stream { render action: "show" }
        format.json { render :show, status: :ok, location: @kindlelist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
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
    params.require(:kindlelist).permit(:asin, :title, :publisher, :author, :publish_date, :purchase_date, :readstatus_id, :category_id)
  end
end
