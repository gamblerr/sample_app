class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      # @count = 0
      @feed_items = current_user.feed.not_replies.paginate(page: params[:page],per_page: 10)
    end
  end

  def search
    if signed_in?
      @micropost  = current_user.microposts.build
      @query_string = params[:query]
      if @query_string.present?
        index_models = params[:type] || ["user","micropost"]
        index_models = index_models.collect{|m| m.capitalize.constantize.searchkick_index.name}
        @searchitems = Micropost.search(params[:query], index_name: index_models, fields: [{name: :word_start},{username: :word_start},{content: :word_middle}],highlight: {tag: "<strong>"},misspellings: false).with_details.paginate(page: params[:page],per_page: 10)
      else
        flash[:error] = "Enter a search item"
        redirect_to root_url
      end
    else
      flash[:error] = " Please Sign up or Sign in "
      redirect_to root_url
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
