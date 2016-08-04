module Dallal
  module Events
    module Publisher
      extend ::ActiveSupport::Concern

      included do
        class_attribute :pub_sub_namespace

        self.pub_sub_namespace = 'dallals'
      end

      #def broadcast_event(name, payload = {})
      #  if block_given?
      #    self.class.broadcast_event(name, payload) do
      #      yield
      #    end
      #  else
      #    self.class.broadcast_event(name, payload)
      #  end
      #end

      def broadcast(info)
        self.class.broadcast(info)
      end

      module ClassMethods
        # Broadcast to dallals
        def broadcast(info)
          ActiveSupport::Notifications.instrument(self.pub_sub_namespace, info)
        end

        def broadcast_event(name, payload = {})
          if block_given?
            ActiveSupport::Notifications.instrument(name, payload) do
              yield
            end
          else
            ActiveSupport::Notifications.instrument(name, payload)
          end
        end
      end
    end
  end
end
