module Dallal
  module Events
    class EventPublisher
      include Dallal::Events::Publisher
      self.pub_sub_namespace = 'dallals'
    end
  end
end
