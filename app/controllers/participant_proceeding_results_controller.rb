class ParticipantProceedingResultsController < ApplicationController
  before_filter :auth_check
  before_action :set_participant_proceeding_result, only: [:show, :edit, :update, :destroy]

  # GET /participant_proceeding_results
  # GET /participant_proceeding_results.json
  def index
    @participant_proceeding_results = ParticipantProceedingResult.all
  end

  # GET /participant_proceeding_results/1
  # GET /participant_proceeding_results/1.json
  def show
  end

  # GET /participant_proceeding_results/new
  def new
    @participant_proceeding_result = ParticipantProceedingResult.new
  end

  # GET /participant_proceeding_results/1/edit
  def edit
  end

  # POST /participant_proceeding_results
  # POST /participant_proceeding_results.json
  def create
    @participant_proceeding_result = ParticipantProceedingResult.new(participant_proceeding_result_params)

    respond_to do |format|
      if @participant_proceeding_result.save
        format.html { redirect_to @participant_proceeding_result, notice: 'Participant proceeding result was successfully created.' }
        format.json { render :show, status: :created, location: @participant_proceeding_result }
      else
        format.html { render :new }
        format.json { render json: @participant_proceeding_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participant_proceeding_results/1
  # PATCH/PUT /participant_proceeding_results/1.json
  def update
    respond_to do |format|
      if @participant_proceeding_result.update(participant_proceeding_result_params)
        format.html { redirect_to @participant_proceeding_result, notice: 'Participant proceeding result was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant_proceeding_result }
      else
        format.html { render :edit }
        format.json { render json: @participant_proceeding_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_proceeding_results/1
  # DELETE /participant_proceeding_results/1.json
  def destroy
    @participant_proceeding_result.destroy
    respond_to do |format|
      format.html { redirect_to participant_proceeding_results_url, notice: 'Participant proceeding result was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant_proceeding_result
      @participant_proceeding_result = ParticipantProceedingResult.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_proceeding_result_params
      params.require(:participant_proceeding_result).permit(:participant_proceeding, :results, :checked)
    end
end
