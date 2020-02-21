# frozen_string_literal: true
require_relative '../models/post'

class PostsController < ApplicationController
  def new
    # if params[:wall_id] != nil
    #   @user = User.find(params[:wall_id])
    # end
    @post = Post.new

  end

  def create
    @current_user = current_user
    p 'post params'
    p post_params
    p 'current user'
    p @current_user
    p 'posts'
    p @current_user.posts
    @post = @current_user.posts.create(post_params)
    redirection(@post)
  end

  def index
    authenticate_user
    @posts = Post.show
  end

  def edit
    @post = Post.find(params[:id])
    if users_post(@post) && Post.under_ten_mins(@post)
      render 'edit'
    else
      redirection(@post)
      flash[:alert] = "Sorry you cannot edit this post"
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirection(@post)
  end

  def destroy
    @post = Post.find(params[:id])
    if users_post(@post)
      @post.destroy
      redirection(@post)
    else
      redirection(@post)
      flash[:alert] = "Sorry you cannot delete another User\'s posts"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def redirection(post)
    if users_post(post)
      redirect_to "/#{post.wall_id}"
    else 
      redirect_to '/'
    end 
  end

  def users_post(post)
    post.user_id == current_user.id
  end

  def post_params
    params.require(:post).permit(:message, :wall_id, :image)
  end

  def authenticate_user
    redirect_to '/users/sign_in' unless user_signed_in?
  end
end
