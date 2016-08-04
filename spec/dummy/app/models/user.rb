class User < ActiveRecord::Base
  include Dallal
  has_many :posts
end
