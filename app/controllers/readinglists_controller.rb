class ReadinglistsController < ApplicationController
  before_action :set_readinglist, only: %i[show edit update destroy]
  before_action :set_select_options, only: %i[index new edit]

  # GET /readinglists or /readinglists.json
  def index
    # @readinglists = Readinglist.all
    @search = Readinglist.ransack(params[:q])
    @search.sorts = "date desc" if @search.sorts.empty?
    @readinglists = @search.result.page(params[:page])

    # @readinglists = Readinglist.all

    # readinglist = ReadinglistsHelper::Readinglistx.new("Readinglist", @readinglists)
    respond_to do |format|
      # format.html { render TblComponent.new(name: readinglist.name, header: readinglist.header, body: readinglist.body) }
      format.html { render locals: { rl: readinglist, paginatex: @readinglists } }
      format.json { render :show, status: :created, location: @kindlelist }
    end
  end

  # GET /readinglists/1 or /readinglists/1.json
  def show; end

  # GET /readinglists/new
  def new
    @readinglist = Readinglist.new
    # @category_list = CategoriesHelper::get_list()
    # @readinglist = Readinglist.new
  end

  # GET /readinglists/1/edit
  def edit
    # @category_list = CategoriesHelper::get_list()
  end

  # POST /readinglists or /readinglists.json
  def create
    @readinglist = Readinglist.new(readinglist_params)
    @readinglist["register_date"] = Date.today
    @readinglist["status"] = @readinglist.readstatus.name
    logger.debug @readinglist

    respond_to do |format|
      ret = false
      begin
        ret = @readinglist.save!
      rescue StandardError => exception
        logger.fatal exception.message
      end
      if ret
        format.html { render }
        format.turbo_stream { render }
        format.json { render :show, status: :created, location: @kindlelist }
      else
        @readstatus_list = ReadstatusesHelper.list()
        # @category_list = CategoriesHelper::get_list()
        logger.debug "create ret=#{ret} 2"
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @kindlelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /readinglists/1 or /readinglists/1.json
  def update
    respond_to do |format|
      if @readinglist.update(readinglist_params)
        format.html {}
        format.turbo_stream { render action: "show" }
        format.json { render :show, status: :ok, location: @kindlelist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.json { render json: @kindlelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /readinglists/1 or /readinglists/1.json
  def destroy
    @readinglist.destroy
    flash.now.notice = "bookを作治しました"

    respond_to do |format|
      format.html {}
      format.turbo_stream {}
      format.json { head :no_content }
    end
  end

  private

=begin
  def set_q
    @q = Readinglist.ransack(params[:q])
    @q.sorts = "id desc" if @q.sorts.empty?
    @result = @q.result(distince: true)
    # @result = params[:q]&.values&.reject(&blank?)
  end
=end
  # Use callbacks to share common setup or constraints between actions.
  def set_readinglist
    @readinglist = Readinglist.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def readinglist_params
    params.require(:readinglist).permit(:register_date, :date, :title, :status, :shape, :isbn)
  end
end
