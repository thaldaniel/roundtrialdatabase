class RoundtrialsController < ApplicationController
  before_filter :auth_check
  before_action :set_roundtrial, only: [:show, :edit, :update, :destroy]

  # GET /roundtrials
  # GET /roundtrials.json
  def index
    @roundtrials = Roundtrial.all
  end

  # GET /roundtrials/1
  # GET /roundtrials/1.json
  def show
  end

  # GET /roundtrials/new
  def new
    @roundtrial = Roundtrial.new
  end

  # GET /roundtrials/1/edit
  def edit
  end

  # POST /roundtrials
  # POST /roundtrials.json
  def create
    @roundtrial = Roundtrial.new(roundtrial_params)

    respond_to do |format|
      if @roundtrial.save
        format.html { redirect_to @roundtrial, notice: 'Roundtrial was successfully created.' }
        format.json { render :show, status: :created, location: @roundtrial }
      else
        format.html { render :new }
        format.json { render json: @roundtrial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roundtrials/1
  # PATCH/PUT /roundtrials/1.json
  def update
    respond_to do |format|
      if @roundtrial.update(roundtrial_params)
        format.html { redirect_to @roundtrial, notice: 'Roundtrial was successfully updated.' }
        format.json { render :show, status: :ok, location: @roundtrial }
      else
        format.html { render :edit }
        format.json { render json: @roundtrial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roundtrials/1
  # DELETE /roundtrials/1.json
  def destroy
    @roundtrial.destroy
    respond_to do |format|
      format.html { redirect_to roundtrials_url, notice: 'Roundtrial was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roundtrial
      @roundtrial = Roundtrial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def roundtrial_params
      params.require(:roundtrial).permit(:name, :active)
    end
end
