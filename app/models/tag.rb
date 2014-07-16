class Tag < ActiveRecord::Base
  attr_accessible :micropost_id, :tag_name
  searchkick
end
