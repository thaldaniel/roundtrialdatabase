class ParticipantProceedingsController < ApplicationController
  before_filter :auth_check
  before_action :set_participant_proceeding, only: [:show, :edit, :update, :destroy]

  # GET /participant_proceedings
  # GET /participant_proceedings.json
  def index
    @participant_proceedings = ParticipantProceeding.all
  end

  # GET /participant_proceedings/1
  # GET /participant_proceedings/1.json
  def show
  end

  # GET /participant_proceedings/new
  def new
    @participant_proceeding = ParticipantProceeding.new
  end

  # GET /participant_proceedings/1/edit
  def edit
  end

  # POST /participant_proceedings
  # POST /participant_proceedings.json
  def create
    @participant_proceeding = ParticipantProceeding.new(participant_proceeding_params)

    respond_to do |format|
      if @participant_proceeding.save
        format.html { redirect_to @participant_proceeding, notice: 'Participant proceeding was successfully created.' }
        format.json { render :show, status: :created, location: @participant_proceeding }
      else
        format.html { render :new }
        format.json { render json: @participant_proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participant_proceedings/1
  # PATCH/PUT /participant_proceedings/1.json
  def update
    respond_to do |format|
      if @participant_proceeding.update(participant_proceeding_params)
        format.html { redirect_to @participant_proceeding, notice: 'Participant proceeding was successfully updated.' }
        format.json { render :show, status: :ok, location: @participant_proceeding }
      else
        format.html { render :edit }
        format.json { render json: @participant_proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participant_proceedings/1
  # DELETE /participant_proceedings/1.json
  def destroy
    @participant_proceeding.destroy
    respond_to do |format|
      format.html { redirect_to participant_proceedings_url, notice: 'Participant proceeding was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participant_proceeding
      @participant_proceeding = ParticipantProceeding.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_proceeding_params
      params.require(:participant_proceeding).permit(:participant_id, :proceeding_id, :device_id, :metadata)
    end
end
