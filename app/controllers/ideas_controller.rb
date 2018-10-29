class IdeasController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :find_idea, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def new
    @idea = Idea.new
  end

  def create
    delete_danger
    @idea = Idea.new(idea_params)
    @idea.user = current_user

    if @idea.save
      redirect_to idea_path(@idea.id)
    else
      render :new
    end
  end

  def index
    delete_danger
    @ideas = Idea.all.order(created_at: :desc)
  end

  def show
    @reviews = @idea.reviews.order(created_at: :desc)
    @review = Review.new
  end

  def edit
  end

  def update
    if @idea.update(idea_params)
      delete_danger
      redirect_to idea_path(@idea.id)
    else
      render :edit
    end
  end

  def destroy
    @idea.destroy
    redirect_to root_path
  end

  private
  def find_idea
    @idea = Idea.find params[:id]
  end

  def idea_params
    params.require(:idea).permit(:title, :description)
  end

  def authorize_user!
    unless can? :crud, @idea
      flash[:warning] = "Sign in or sign up first!"
      redirect_to root_path
    end
  end
end