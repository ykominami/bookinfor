class BookstoresController < ApplicationController
  before_action :set_bookstore, only: %i[ show edit update destroy ]

  # GET /bookstores or /bookstores.json
  def index
    @bookstores = Bookstore.all
  end

  # GET /bookstores/1 or /bookstores/1.json
  def show
  end

  # GET /bookstores/new
  def new
    @bookstore = Bookstore.new
  end

  # GET /bookstores/1/edit
  def edit
  end

  # POST /bookstores or /bookstores.json
  def create
    @bookstore = Bookstore.new(bookstore_params)

    respond_to do |format|
      if @bookstore.save
        format.html { redirect_to bookstore_url(@bookstore), notice: "Bookstore was successfully created." }
        format.json { render :show, status: :created, location: @bookstore }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bookstore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookstores/1 or /bookstores/1.json
  def update
    respond_to do |format|
      if @bookstore.update(bookstore_params)
        format.html { redirect_to bookstore_url(@bookstore), notice: "Bookstore was successfully updated." }
        format.json { render :show, status: :ok, location: @bookstore }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bookstore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookstores/1 or /bookstores/1.json
  def destroy
    @bookstore.destroy!

    respond_to do |format|
      format.html { redirect_to bookstores_url, notice: "Bookstore was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bookstore
      @bookstore = Bookstore.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookstore_params
      params.require(:bookstore).permit(:name)
    end
end
