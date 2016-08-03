class User < ActiveRecord::Base
  include UserNotification
  has_many :posts
end
