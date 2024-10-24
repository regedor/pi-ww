class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendars
  before_action :set_calendar, only: [ :edit, :update, :destroy ]
  before_action :check_organization!, only: [ :edit, :update, :destroy ]

  # GET /calendars
  def index
    @calendar = Calendar.new
    @consultations = Consultation.where(
      start_time: Time.now.beginning_of_month.beginning_of_week..Time.now.end_of_month.end_of_week
    )
    @posts = Post.where(calendar: @calendars).where(
      publish_date: Time.now.beginning_of_month.beginning_of_week..Time.now.end_of_month.end_of_week
    )
  end

  # POST /calendars
  def create
    @calendar = Calendar.new(calendar_params)
    @calendar.organization = current_user.organization

    if @calendar.save
      redirect_to "/calendars", notice: "Calendar was successfully created."

      LogEntry.create_log("Calendar has been created by #{current_user.email}. [#{calendar_params}]")
    else
      render :index, status: :unprocessable_entity

      LogEntry.create_log("Failed to create calendar by #{current_user.email}. [#{calendar_params}]")
    end
  end

  # GET /calendars/:id/edit
  def edit
  end

  # PATCH/PUT /calendars/:id
  def update
    @calendar.organization = current_user.organization
    if @calendar.update(calendar_params)
      redirect_to "/calendars", notice: "Calendar was successfully updated."

      LogEntry.create_log("Calendar has been updated by #{current_user.email}. [#{calendar_params}]")
    else
      render :edit, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to update calendar (unprocessable_entity). [#{calendar_params}]")
    end
  end

  # DELETE /calendars/:id
  def destroy
    @calendar.destroy
    redirect_to calendars_url, notice: "Calendar was successfully destroyed."

    LogEntry.create_log("Calendar has been destroyed by #{current_user.email}. [#{calendar_params}]")
  end

  def selector
  end

  def select_calendar
    if params[:calendar][:calendar_id].present?
      redirect_to new_calendar_post_path(Calendar.find(params[:calendar][:calendar_id]))
    else
      redirect_to selector_calendars_path, alert: "Select a calendar."
    end
  end

  private
    def set_calendars
      @calendars = Calendar.where(organization: current_user.organization)
    end
    # Find the calendar for actions like show, edit, update, destroy
    def set_calendar
      @calendar = Calendar.find(params[:id])
    end

    # Strong parameters: Only allow the trusted parameters for calendar
    def calendar_params
      params.require(:calendar).permit(:name)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization_id
    end
end