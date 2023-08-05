class AbcsController < ApplicationController
  before_action :set_abc, only: %i[ show edit update destroy ]

  # GET /abcs or /abcs.json
  def index
    @search = Abc.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @abcs = @search.result.page(params[:page])
  end

  def index0
    @abcs = Abc.all
    name = "Table 1"
    header = ["話題", "スコア"]
    choice_names = {4 => "ch_a", 5 => "ch_b", 6 => "ch_c", 7 => "ch_d"}
    points = [3, 2, 1, 0]

    AbcsHelper::Choicex.init(points, choice_names)
    # p AbcsHelper::Choicex.get_name_values

    ts = AbcsHelper::TotalScorex.new(header)

    votea_result = [4, 5, 6, 7]
    votea = AbcsHelper::Votex.new("a", votea_result)

    voteb_result = [6, 7, 5, 4]
    voteb = AbcsHelper::Votex.new("b", voteb_result)

    votec_result = [7, 5, 4, 6]
    votec = AbcsHelper::Votex.new("c", votec_result)

    ts.add_or_change(votea)
    ts.add_or_change(voteb)
    ts.add_or_change(votec)
    
    render(TableComponent.new(name: name, total_score: ts))
  end

  # GET /abcs/1 or /abcs/1.json
  def show
  end

  # GET /abcs/new
  def new
    @abc = Abc.new
  end

  # GET /abcs/1/edit
  def edit
  end

  # POST /abcs or /abcs.json
  def create
    @abc = Abc.new(abc_params)

    respond_to do |format|
      if @abc.save
        format.html { redirect_to abc_url(@abc), notice: "Abc was successfully created." }
        format.json { render :show, status: :created, location: @abc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @abc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /abcs/1 or /abcs/1.json
  def update
    respond_to do |format|
      if @abc.update(abc_params)
        format.html { redirect_to abc_url(@abc), notice: "Abc was successfully updated." }
        format.json { render :show, status: :ok, location: @abc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @abc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /abcs/1 or /abcs/1.json
  def destroy
    @abc.destroy

    respond_to do |format|
      format.html { redirect_to abcs_url, notice: "Abc was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_abc
      @abc = Abc.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def abc_params
      params.require(:abc).permit(:zid, :s)
    end
end
