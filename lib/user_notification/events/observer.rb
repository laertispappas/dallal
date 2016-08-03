# TODO Move to other module
module UserNotification
  module Events
    class Observer
      NOTIFIABLES = []

      def self.inherited(base)
        model_name = base.name.gsub('Notifier', '')
        validate_model_exists!(model_name)

        NOTIFIABLES << model_name
      end

      def self.callbacks
        @__notification_callbacks ||= []
      end

      def self.on *args, &block
        opts = args.extract_options!
        callbacks << { on: args, opts: opts, block: block }
      end

      def self.create_notification(id:, event:)
        # TODO This loops on all callbacks. Rethink this
        # method and implement it differently. Add listeners?
        callbacks.each do |callback|
          next unless callback[:on].include?(event)
          obj = model_class.constantize.find(id)
          notification = UserNotification::Notification.new(event: event, model_class: model_class, opts: callback[:opts], _object: obj)
          notification.define_singleton_method(model_class.underscore) do
            obj
          end
          notification.instance_eval(&callback[:block])
          notification.dispatch!
        end
      end


      private

      def self.model_class
        self.name.gsub('Notifier', '')
      end

      def self.validate_model_exists!(model)
        unless Object.const_defined?(model)
          # TODO add more descriptive error
          # also fix this
          # raise "Model #{model} is not defined."
        end
      end
    end
  end
end
