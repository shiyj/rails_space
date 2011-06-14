# encoding: utf-8
class PostsController < ApplicationController
  helper :profile
  before_filter :protect, :protect_blog

  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.find_all_by_blog_id(params[:blog_id]).paginate(:page => params[:page],:per_page=>10)
    @title="博客管理"

    # respond_to 函数使URL能够对不同的格式作出不同的应答。
    # format.html,即响应html格式的，.xml即相应xml格式。
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    @rest_url=blog_posts_path
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @rest_url=blog_post_path(@post.blog_id,@post)
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.blog_id=params[:blog_id]
    respond_to do |format|
      if @post.save
        #如果保存成功则将页面重新定向到所有的发表posts中。
        format.html { redirect_to(blog_posts_path, :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post}
      else
        format.html {render new_blog_post_path }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(blog_post_path(params[:blog_id],@post), :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(blog_posts_url) }
      format.xml  { head :ok }
    end
  end
  private

  def protect_blog
    @blog=Blog.find(params[:blog_id])
    user=User.find(session[:user_id])
    unless @blog.user==user
      flash[:notice]= "这不是你的博客"
      redirect_to :action=>"index",:controller=>"user"
      return false
    end
  end
end

