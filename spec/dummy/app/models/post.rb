class Post < ActiveRecord::Base
  include UserNotification
  belongs_to :user
end
