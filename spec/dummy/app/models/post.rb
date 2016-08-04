class Post < ActiveRecord::Base
  include Dallal
  belongs_to :user
end
