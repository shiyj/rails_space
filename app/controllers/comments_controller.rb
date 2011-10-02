class CommentsController < ApplicationController
  helper :profile,:avatar
  include ProfileHelper
  before_filter :protect,:load_post

  def new
    @comment=Comment.new
    respond_to do |format|
      format.js do
        render :update do |page|
          page.hide "add_comment_link_for_post_#{@post.id}"
          page.replace_html "new_comment_form_for_post_#{@post.id}",:partial=>"new"
        end
      end
    end
  end

  private
  def load_post
    @post=Post.find(params[:post_id])
  end
end
