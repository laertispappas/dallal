class PostNotifier < UserNotification::Events::Observer
  on :create do
    notify post.user do
      with :email, if: nil do
        template :register
      end
    end
  end
end
