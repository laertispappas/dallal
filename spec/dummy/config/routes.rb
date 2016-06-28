Rails.application.routes.draw do

  mount UserNotification::Engine => "/user_notification"
end
