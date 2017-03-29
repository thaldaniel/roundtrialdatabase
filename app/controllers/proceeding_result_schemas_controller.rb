class ProceedingResultSchemasController < ApplicationController
  before_filter :auth_check
  before_action :set_proceeding_result_schema, only: [:show, :edit, :update, :destroy]

  # GET /proceeding_result_schemas
  # GET /proceeding_result_schemas.json
  def index
    @proceeding_result_schemas = ProceedingResultSchema.all
  end

  # GET /proceeding_result_schemas/1
  # GET /proceeding_result_schemas/1.json
  def show
  end

  # GET /proceeding_result_schemas/new
  def new
    @proceeding_result_schema = ProceedingResultSchema.new
  end

  # GET /proceeding_result_schemas/1/edit
  def edit
  end

  # POST /proceeding_result_schemas
  # POST /proceeding_result_schemas.json
  def create
    @proceeding_result_schema = ProceedingResultSchema.new(proceeding_result_schema_params)

    respond_to do |format|
      if @proceeding_result_schema.save
        format.html { redirect_to @proceeding_result_schema, notice: 'Proceeding result schema was successfully created.' }
        format.json { render :show, status: :created, location: @proceeding_result_schema }
      else
        format.html { render :new }
        format.json { render json: @proceeding_result_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /proceeding_result_schemas/1
  # PATCH/PUT /proceeding_result_schemas/1.json
  def update
    respond_to do |format|
      if @proceeding_result_schema.update(proceeding_result_schema_params)
        format.html { redirect_to @proceeding_result_schema, notice: 'Proceeding result schema was successfully updated.' }
        format.json { render :show, status: :ok, location: @proceeding_result_schema }
      else
        format.html { render :edit }
        format.json { render json: @proceeding_result_schema.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /proceeding_result_schemas/1
  # DELETE /proceeding_result_schemas/1.json
  def destroy
    @proceeding_result_schema.destroy
    respond_to do |format|
      format.html { redirect_to proceeding_result_schemas_url, notice: 'Proceeding result schema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proceeding_result_schema
      @proceeding_result_schema = ProceedingResultSchema.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proceeding_result_schema_params
      params.require(:proceeding_result_schema).permit(:proceeding_id, :result_schema, :metadata_schema)
    end
end
