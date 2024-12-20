class PipeattributesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pipeline
  before_action :check_organization!
  before_action :set_pipeattribute, only: [ :edit, :update, :destroy ]

  # POST /pipeline/:pipeline_id/pipeattribute
  def create
    @pipeattribute = @pipeline.pipeattributes.new(pipeattribute_params)

    if @pipeattribute.save
      @pipeline.leads.map { |l| l.leadcontents.new(value: "", lead: l, pipeattribute: @pipeattribute) }.each { |l| l.save }
      redirect_to pipeline_path(@pipeline), notice: "Pipeattribute was successfully created."
    else
      error_messages = @pipeattribute.errors.full_messages.join(", ")
      redirect_back(fallback_location: pipeline_path(@pipeline), alert: "Failed to create Pipeattribute: #{error_messages}")
    end
  end

  # PATCH /pipeline/:pipeline_id/pipeattribute/:pipeattribute_id/edit
  def edit
  end

  # PATCH /pipeline/:pipeline_id/pipeattribute/:pipeattribute_id
  def update
    if @pipeattribute.update(pipeattribute_params)
      redirect_to pipeline_path(@pipeline), notice: "Pipeattribute was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /pipeline/:pipeline_id/pipeattribute/:pipeattribute_id
  def destroy
    @pipeattribute.destroy!
    redirect_to pipeline_path(@pipeline), notice: "Pipeattribute was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pipeattribute
      @pipeattribute = @pipeline.pipeattributes.find(params[:id])
    end

    def set_pipeline
      @pipeline = Pipeline.find(params[:pipeline_id])
    end

    def pipeattribute_params
      params.require(:pipeattribute).permit(:name)
    end

    def check_organization!
      redirect_to request.referrer || root_path, alert: "Access Denied" unless current_user.organization_id == @pipeline.organization_id
    end
end
