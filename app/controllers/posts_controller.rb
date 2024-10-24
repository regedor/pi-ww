class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_calendar
  before_action :check_organization!
  before_action :set_post, only: [ :show, :edit, :update, :destroy, :approved, :in_analysis, :rejected ]
  before_action :check_author!, only: [ :edit, :update, :destroy ]
  before_action :sanitize_categories, only: [ :create, :update ]

  # GET /calendars/:calendar_id/posts/:id
  def show
    @perspective = Perspective.where(post: @post, socialplatform: nil).first
    if @perspective
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective)
    else
      redirect_to calendars_path()
    end
  end

  # GET /calendars/:calendar_id/posts/new
  def new
    @post = @calendar.posts.new
    @perspective = @post.perspectives.new
  end

  # POST /calendars/:calendar_id/posts
  def create
    @post = @calendar.posts.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully created."

      LogEntry.create_log("Post has been created by #{current_user.email}. [#{post_params}]")
    else
      render :new, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to create post but failed (unprocessable_entity). [#{post_params}]")
    end
  end

  # GET /calendars/:calendar_id/posts/:id/edit
  def edit
  end

  # PATCH /calendars/:calendar_id/posts/:id
  def update
    if @post.update(post_params)
      redirect_to calendar_post_path(@calendar, @post), notice: "Post was successfully updated."

      LogEntry.create_log("Post has been updated by #{current_user.email}. [#{post_params}]")
    else
      render :edit, status: :unprocessable_entity

      LogEntry.create_log("#{current_user.email} attempted to update post but failed (unprocessable_entity). [#{post_params}]")
    end
  end

  # DELETE /calendars/:calendar_id/posts/:id
  def destroy
    @post.destroy
    redirect_to calendars_path(), notice: "Post was successfully deleted."

    LogEntry.create_log("Post has been destroyed by #{current_user.email}. [#{post_params}]")
  end

  # PATCH /calendars/:calendar_id/posts/:id/approved
  def approved
    @post.update(status: "approved")
    redirect_to calendar_post_path(@calendar, @post), notice: "Post status updated to Approved."

    LogEntry.create_log("Post has been approved by #{current_user.email}. [#{post_params}]")
  end

  # PATCH /calendars/:calendar_id/posts/:id/in_analysis
  def in_analysis
    @post.update(status: "in_analysis")
    redirect_to calendar_post_path(@calendar, @post), notice: "Post status updated to In Analysis."

    LogEntry.create_log("Post has been updated to In Analysis by #{current_user.email}. [#{post_params}]")
  end

  # PATCH /calendars/:calendar_id/posts/:id/rejected
  def rejected
    @post.update(status: "rejected")
    redirect_to calendar_post_path(@calendar, @post), notice: "Post status updated to Rejected."

    LogEntry.create_log("Post has been rejected by #{current_user.email}. [#{post_params}]")
  end

  private
    def set_calendar
      @calendar = Calendar.find(params[:calendar_id])
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(
        :title,
        :design_idea,
        :status,
        :publish_date,
        categories: [],
        perspectives_attributes: [
          :copy
        ]
      )
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def check_author!
      redirect_to root_path, alert: "Access Denied" unless current_user == @post.user
    end

    def sanitize_categories
      if params[:post][:categories].present?
        params[:post][:categories] = params[:post][:categories].split(",").map(&:strip).reject(&:blank?)
      end
    end
end
