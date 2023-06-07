class BooklistsController < ApplicationController
  before_action :set_booklist, only: %i[ show edit update destroy index index2 index3 ]
#  before_action :set_booklist, only: %i[ show edit update destroy]

  def index3
    ind = params[:ind]
    if ind
      ind_next = ind.to_i + 1
    else
      ind = 1
      ind_next = 1
    end
    
    respond_to do |format|
      # format.html { render BooklistComponent.new("Booklist" , Booklistloose, params) }
      format.html { render BlComponent.new("Bl component html" , Booklist, params, ind, ind_next, 30) }
      format.turbo_stream { render BlComponent.new("Bl component ts" , Booklist, params, ind, ind_next, 456) }
      format.json { render :show, status: :created, location: @booklist }
    end    
  end

  def index2
    ind = params[:ind]
    if ind
      ind_next = ind.to_i + 1
    else
      ind = 1
      ind_next = 1
    end
    @ind = ind
    @ind_next = ind_next
    respond_to do |format|
      format.turbo_stream { render "index2" , ind_next: ind_next }
      #
      format.json { render :show, status: :created, location: @booklist }
      #
      format.html { render "index2" }
      #
    end    
  end

  def displayx
    ind = params[:ind]
    if ind
      ind_next = ind.to_i + 1
    else
      ind = 1
      ind_next = 1
    end
    @ind = ind
    @ind_next = ind_next

    respond_to do |format|
      format.html { render "displayx" }
      format.turbo_stream { render "displayx" }
    end
  end
  # GET /booklists or /booklists.json
  def index
    # booklist_params

    respond_to do |format|
      # format.html { render BooklistComponent.new("Booklist" , Booklistloose, params) }
      format.html { render BooklistComponent.new("Booklist component Y" , Booklist, params) }
      format.json { render :show, status: :created, location: @booklist }
    end    
  end

  # GET /booklists/1 or /booklists/1.json
  def show
    respond_to do |format|
      # format.html { redirect_to booklist_url(@booklist), notice: "Booklistに登録しました。" }
      format.html { render BooklistitemComponent.new(@booklist) }
      format.json { render :update, status: :created, location: @booklist }
    end
  end

  # GET /booklists/new
  def new
    @booklist = Booklist.new
  end

  # GET /booklists/1/edit
  def edit
  end

  # POST /booklists or /booklists.json
  def create
    @booklist = Booklist.new(booklist_params)
    year = @booklist.purchase_date.year
#    @booklist.xid = BooklistsHelper::get_next_xid(year)
    @booklist.xid = get_next_xid(year)
    @booklist.totalID = "#{year}#{ sprintf("%03d", @booklist.xid.to_i )}"

    if @booklist.save
      flash.now.notice = "Booklistに登録しました。" 

      respond_to do |format|
        # format.html { redirect_to booklist_url(@booklist), notice: "Booklistに登録しました。" }
        format.html { render BooklistComponent.new("Booklist component X" , Booklist, params) }
        format.json { render :update, status: :created, location: @booklist }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @booklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /booklists/1 or /booklists/1.json
  def update
    respond_to do |format|
      if @booklist.update(booklist_params)
        flash.now.notice = "booklistを更新しました。"
        # format.html { redirect_to booklist_url(@booklist), notice: "Booklistを更新しました。" }
        format.html { render BooklistComponent.new("Booklist component X" , Booklist, params) }
        # format.turbo_stream { render :update, status: :ok, location: @booklist }
        format.json { render :show, status: :ok, location: @booklist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booklists/1 or /booklists/1.json
  def destroy
    @booklist.destroy

    respond_to do |format|
      format.html { redirect_to booklists_url, notice: "Booklistを削除しました。" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booklist
      if params[:id]
        @booklist = Booklist.find(params[:id])
      else
        @booklist = Booklist.new
      end
    end

    # Only allow a list of trusted parameters through.
    def booklist_params
      params.require(:booklist).permit(:purchase_date, :bookstore, :title, :asin, :read_status, :shape, :category)
    end

    def get_next_xid(year)
      start_date = "#{year}-01-01"
      end_date = "#{year}-12-31"
      list = Booklist.where(purchase_date: start_date..end_date).pluck(:xid)
      max_number = 0
      max_number = list.max if list
      max_number = 0 unless max_number
      max_number + 1
    end
end
