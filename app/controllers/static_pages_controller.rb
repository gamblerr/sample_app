class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      # @count = 0
      @feed_items = current_user.feed.not_replies.paginate(page: params[:page],per_page: 10)
    end
  end

  def search
    @micropost  = current_user.microposts.build
    # @count = 0
    @query_string = params[:query]
    if @query_string.present?
      index_models = params[:type] || ["user","micropost"]
      @searchitems = Micropost.search(params[:query], index_name: [index_models.collect{|m| m.capitalize.constantize.searchkick_index.name}]).to_a.paginate(page: params[:page],per_page: 10)
      @count = @searchitems.count
      # @users = extract_user_items(@searchitems).paginate(page: params[:page],per_page: 10)
      # @feed_items = extract_feed_items(@searchitems).paginate(page: params[:page],per_page: 10)
    end
  end

  def help
  end

  def about
  end

  def contact
  end

  def extract_user_items(searchitems)
    useritems = []
    searchitems.each do |item|
      if item.is_a?(User)
        useritems << item
    end
  end
    useritems
  end
  def extract_feed_items(searchitems)
    feeditems = []
    searchitems.each do |item|
      if item.is_a?(Micropost)
        feeditems << item
    end
  end
    feeditems
  end
end
