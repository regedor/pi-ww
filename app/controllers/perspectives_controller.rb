require "zip"

class PerspectivesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data
  before_action :check_organization!
  before_action :set_perspective, only: [ :show, :destroy, :update_status, :update_status_post, :update_copy ]

  # GET /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def show
    @attachment = @perspective.attachments.new
    @comment = @post.comments.new
    post_socialplatforms = @post.perspectives.map(&:socialplatform)
    post_perspectives = @post.perspectives
    new_perspectives = Socialplatform.all.reject { |socialplatform| post_socialplatforms.include?(socialplatform) }.map { |s| Perspective.new(socialplatform: s) }
    @perspectives = (post_perspectives + new_perspectives).sort_by { |perspective| perspective.socialplatform.present? ? perspective.socialplatform&.name : "Default" }
    @publishplatform = Publishplatform.where(post: @post).map { |pp| pp.socialplatform }
  end

  # POST /calendars/:calendar_id/posts/:post_id/perspectives
  def create
    @perspective_new = @post.perspectives.new(perspective_params)
    @perspective_new.copy = @post.perspectives.reject { |p| p.socialplatform.present? }.map(&:copy).first

    if @perspective_new.save
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective_new), notice: "Perspective was successfully created."
    else
      @comment = @post.comments.new
      redirect_to calendar_post_perspective_path(@calendar, @post), alert: "Error creating Perspective."
    end
  end

  # DELETE /calendars/:calendar_id/posts/:post_id/perspectives/:id
  def destroy
    if @perspective.socialplatform.nil?
      redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), alert: "Perspective cannot be deleted."
    else
      @perspective.destroy
      redirect_to calendar_post_path(@calendar, @post), notice: "Perspective was successfully destroyed."
    end
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status
  def update_status
    @perspective.update(perspective_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Perspective status updated."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_status_post
  def update_status_post
    @post.update(post_params_status)
    redirect_to calendar_post_perspective_path(@calendar, @post, @perspective), notice: "Post status updated."
  end

  # PATCH /calendars/:calendar_id/posts/:post_id/perspectives/:id/update_copy
  def update_copy
    @perspective.update(perspective_params_copy)
  end

  private
    def set_data
      @calendar = Calendar.find(params[:calendar_id])
      @post = Post.find(params[:post_id])
    end

    def set_perspective
      @perspective = @post.perspectives.find(params[:id])
    end

    def perspective_params
      params.require(:perspective).permit(:socialplatform_id, :copy)
    end

    def check_organization!
      redirect_to root_path, alert: "Access Denied" unless current_user.organization_id == @calendar.organization.id
    end

    def perspective_params_status
      params.require(:perspective).permit(:status)
    end

    def post_params_status
      params.require(:post).permit(:status)
    end

    def perspective_params_copy
      params.require(:perspective).permit(:copy)
    end
end
