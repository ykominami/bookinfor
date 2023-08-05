class EfgsController < ApplicationController
  before_action :set_efg, only: %i[ show edit update destroy ]

  # GET /efgs or /efgs.json
  def index
    @search = Efg.ransack(params[:q])
    @search.sorts = "id desc" if @search.sorts.empty?
    @efgs = @search.result.page(params[:page])
    # @efgs = @search.result(distinct: true).includes(:user).page(params[:page]).order("created_at desc")

    # @efgs = Efg.all
  end

  # GET /efgs/1 or /efgs/1.json
  def show
  end

  # GET /efgs/new
  def new
    @efg = Efg.new
  end

  # GET /efgs/1/edit
  def edit
  end

  # POST /efgs or /efgs.json
  def create
    @efg = Efg.new(efg_params)

    respond_to do |format|
      if @efg.save
        # format.html { redirect_to efg_url(@efg), notice: "Efg was successfully created." }
        format.html { redirect_to efg_url(@efg), notice: "Efg was successfully created." }
        format.turbo_stream { render :create, status: :created, location: @efg }
        format.json { render :show, status: :created, location: @efg }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.json { render json: @efg.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /efgs/1 or /efgs/1.json
  def update
    respond_to do |format|
      if @efg.update(efg_params)
        format.html { redirect_to efg_url(@efg), notice: "Efg was successfully updated." }
        format.json { render :show, status: :ok, location: @efg }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @efg.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /efgs/1 or /efgs/1.json
  def destroy
    @efg.destroy

    respond_to do |format|
      format.html { render }
      format.turbo_stream { render :destroy }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_efg
    @efg = Efg.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def efg_params
    params.require(:efg).permit(:zid, :s)
  end
end
