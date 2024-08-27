class KindlelistsController < ApplicationController
  before_action :set_kindlelist, only: %i[show edit update destroy]
  before_action :set_select_options, only: %i[new edit index create]

  # GET /kindlelists or /kindlelists.json
  def index
    @search = Kindlelist.ransack(params[:q])
    @search.sorts = "purchase_date desc" if @search.sorts.empty?
    @kindlelists = @search.result.page(params[:page])
    # kindlelists = Kindlelist.where("read_status != ?", 4)
    kindlelists = Kindlelist.limit(2)
    # kindlelists = Kindlelist.all
    @kindlelists = kindlelists

    # kindlelist = KindlelistsHelper::Kindlelistx.new("Kindlelist", @kindlelists, view_context)
    respond_to do |format|
      # format.html { render TblComponent.new(name: readinglist.name, header: readinglist.header, body: readinglist.body) }
      format.html { render locals: { listx: kindlelist, paginatex: @kindlelists } }
      format.json { render :show, status: :created, location: @kindlelist }
    end
  end

  # GET /kindlelists/1 or /kindlelists/1.json
  def show; end

  # GET /kindlelists/new
  def new
    @kindlelist = Kindlelist.new
  end

  # GET /kindlelists/1/edit
  def edit; end

  # POST /kindlelists or /kindlelists.json
  def create
    @kindlelist = Kindlelist.new(kindlelist_params)

    respond_to do |format|
      ret = false
      begin
        ret = @kindlelist.save
      rescue StandardError => exception
        logger.fatal exception.message
      end
      if ret
        flash.now.notice = "Kindlelistに登録しました。"
        format.html {}
        format.turbo_stream {}
        format.json { render :show, status: :created, location: @kindlelist }
      else
        logger.debug "create ret=#{ret} 2"
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
        # format.html { redirect_to kindlelist_url(@kindlelist), notice: "Kindlelist was successfully updated." }
        format.html { }
        # format.html { redirect_to kindlelist_url(@kindlelist), notice: "Kindlelist was successfully updated." }
        format.turbo_stream { render locals: { inst: @kindlelist } }
        # format.turbo_stream { render action: "show" }
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
      format.html {}
      format.turbo_stream {}
      format.json { head :no_content }
    end
  end

  private

  def set_select_options
    @readstatus_list = Readstatus.all
    @shape_list = Shape.all
    @category_list = Category.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_kindlelist
    if params[:id]
      @kindlelist = Kindlelist.find(params[:id])
    else
      @kindlelist = Kindlelist.new
    end
  end

  # Only allow a list of trusted parameters through.
  def kindlelist_params
    params.require(:kindlelist).permit(:asin, :title, :publisher, :author, :publish_date, :purchase_date, :readstatus_id, :category_id, :shape_id)
  end
end
