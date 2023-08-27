class CalibrelistsController < ApplicationController
  before_action :set_calibrelist, only: %i[ show edit update destroy ]
  before_action :set_select_options, only: %i[ new edit index ]

  # GET /calibrelists or /calibrelists.json
  def index
    @search = Calibrelist.ransack(params[:q])
    @search.sorts = "timestamp desc" if @search.sorts.empty?
    @calibrelists = @search.result.page(params[:page])

    # calibrelist = CalibrelistsHelper::Calibrelistx.new("Calibrelist", @calibrelists)
    respond_to do |format|
      # format.html { render TblComponent.new(name: calibrelist.name, header: calibrelist.header, body: calibrelist.body) }
      format.html { }
      format.json { render :show, status: :created, location: @calibrelist }
    end    
  end

  # GET /calibrelists/1 or /calibrelists/1.json
  def show
    respond_to do |format|
      format.html { render }
      format.json { render :update, status: :created, location: @booklist }
    end
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
    param = calibrelist_params
    xid = Calibrelist.pluck{:xid}.max.first
    new_xid = xid + 1
    new_str = "#{new_xid}"
    new_timestamp = DateTime.new
    param["xid"] = new_xid
=begin
    param["xxid"] =  new_str
    param["isbn"] = new_xid 
    param["zid"] = new_xid
    param["uuid"] = new_xid 
    param["series_index"] = new_xid 
    param["title_sort"] =  new_str
    param["library_name"] =  new_str
    param["formats"] =  new_str
    param["timestamp"] = new_timestamp 
    param["pubdate"] =  new_timestamp
    param["publisher"] =  new_str
    param["author_sort"] =  new_str
    param["languages"] =  new_str
#    param[""] =  new_str
=end
    @calibrelist = Calibrelist.new(param)

    respond_to do |format|
      if @calibrelist.save!
        format.html { }
        format.turbo_stream { }
        format.json { render :show, status: :created, location: @calibrelist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @calibrelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calibrelists/1 or /calibrelists/1.json
  def update
    respond_to do |format|
      if @calibrelist.update(calibrelist_params)
        flash.now.notice = "calibrelistを更新しました。"
        format.html {  }
        format.turbo_stream { }
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
      format.html {  }
      format.turbo_stream { }
      format.json { head :no_content }
    end
  end

  private

    def set_select_options
      @readstatus_list = Readstatus.all
      @shape_list = Shape.all
      @category_list = Category.all
      @shape_list = Shape.all
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_calibrelist
      @calibrelist = Calibrelist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def calibrelist_params
      params.require(:calibrelist).permit(:xid, :xxid, :isbn, 
        :zid, :uuid, :comments, :size, :series, :series_index, 
        :title, :title_sort, :tags, :library_name, :formats, 
        :timestamp, :pubdate, :publisher, :authors, :author_sort, 
        :languages, :shape_id,:readstatus_id, :category_id)
    end
end
