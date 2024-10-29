class PipelinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipelines
  before_action :set_pipeline, only: %i[ edit update destroy ]

  # GET /pipelines or /pipelines.json
  def index
  end

  # GET /pipelines/new
  def new
    @pipeline = Pipeline.new
  end

  # GET /pipelines/1/edit
  def edit
  end

  # POST /pipelines or /pipelines.json
  def create
    @pipeline = Pipeline.new(pipeline_params)
    @pipeline.organization = current_user.organization

    if @pipeline.save
      redirect_to pipelines_path, notice: "Pipeline was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pipelines/1 or /pipelines/1.json
  def update
    if @pipeline.update(pipeline_params)
      redirect_to pipelines_path, notice: "Pipeline was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pipelines/1 or /pipelines/1.json
  def destroy
    @pipeline.destroy!
    redirect_to pipelines_path, status: :see_other, notice: "Pipeline was successfully destroyed."
  end

  def selector
  end

  def select_pipeline
    if params[:pipeline][:pipeline_id].present?
      redirect_to new_pipeline_lead_path(Pipeline.find(params[:pipeline][:pipeline_id]))
    else
      redirect_to selector_pipelines_path, alert: "Select a pipeline."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeline
      @pipeline = Pipeline.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pipeline_params
      params.require(:pipeline).permit(:name)
    end

    def set_pipelines
      @pipelines = Pipeline.where(organization: current_user.organization)
    end
end
