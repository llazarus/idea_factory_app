class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy ]
  before_action :find_review, only: [ :destroy ]
  before_action :authorize_user!, only: [ :destroy ]

  def create
    @idea = Idea.find params[:idea_id]
    @review = Review.new review_params
    @review.idea = @idea
    @review.user = current_user

    if @review.save
      delete_danger
      redirect_to idea_path(@idea.id)
    else
      flash[:danger] = "#{@comment.errors.full_messages.join(" • ")}"
      @comments = @post.comments.order(created_at: :desc) 
      render "posts/show"
    end
  end

  def destroy
    @review.destroy
    redirect_to idea_path(@review.idea.id)
  end

  private
  def review_params
    params.require(:review).permit(:body)
  end

  def find_review
    @review = Review.find params[:id]
  end

  def authorize_user!
    unless can? :crud, @review
      flash[:danger] = "Access denied!"
      redirect_to root_path
    end
  end
end