class PostNotifier < Dallal::Events::Observer
  on :create do
    notify post.user do
      with :email, if: nil do
        template :register
      end

      with :api do
        payload({
                    message: 'New Poll Created',
                    event: 'Create'
                })
        method :post
        # client 'Services::MyClient'
        path 'http://localhost/'
      end
    end
  end
end
