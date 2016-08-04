module Dallal
  class DallalJob < ActiveJob::Base
    queue_as :default

    # TODO This is tricky. Event is string here. Is transformed in
    # event_subscriber from sym to string. we transform here egain to
    # sym. Rethink this
    # or user.notify....
    def perform(klass, id, event)
      "#{klass}_notifier".classify.constantize.create_notification(id: id, event: event.to_sym)
    end
  end
end
