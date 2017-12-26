class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :kontrol, :like, :unlike]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end
  
  def like
    @l = Like.new
    @l.post = @post
    @l.user = current_user
    @l.save
    respond_to do |format|
      format.js {render layout: false }
      format.json
    end
  end
  def unlike
    @l = Like.where(post: @post ,user: current_user).first
    @l.destroy
    respond_to do |format|
      format.js {render layout: false }
      format.json
    end
  end
      

  # GET /posts/1
  # GET /posts/1.json
  def show
    @likeds = Like.where(post: @post).all
    @comments=@post.comments.all
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.user != current_user
          format.html { redirect_to @post, notice: 'You are not allowed to do this.' }
          format.json { render :show }
      else
        if @post.update(post_params)
          format.html { redirect_to @post, notice: 'Post was successfully updated.' }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    if @post.user == current_user
      @post.destroyrespond_to do |format|
        format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      @post.destroyrespond_to do |format|
        format.html { redirect_to posts_url, notice: 'You are not allowed to do this!' }
        format.json { head :no_content }
      end
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:msg, :image)
    end
end