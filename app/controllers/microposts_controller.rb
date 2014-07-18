class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      @micropost.micropost_extract()
      @feed_item = @micropost.in_reply_to || @micropost
      @micropost  = current_user.microposts.build
      respond_to do |format|
        format.html { 
          flash[:success] = "Successfully Posted!"
          redirect_to root_url 
        }
        format.js
      end
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def destroy
    if @micropost.in_reply_to.present?
      @feed_item = @micropost.in_reply_to
      @micropost.destroy
       @micropost  = current_user.microposts.build
      respond_to do |format|
        format.html { redirect_to @root_url }
        format.js
      end
    else
      replies = @micropost.replies || []
      replies.each do |reply|
        reply.destroy
      end
      @micropost.destroy
      redirect_to root_url
    end
  end

  private
  
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
end