module UserNotification
  module AbstractInterface
    class InterfaceNotImplementedError < NotImplementedError
    end

    def self.included(klass)
      klass.send(:include, AbstractInterface::Methods)
      klass.send(:extend, AbstractInterface::Methods)
      klass.send(:extend, AbstractInterface::ClassMethods)
    end

    module Methods
      def api_not_implemented(klass)
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
        raise AbstractInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
      end
    end

    module ClassMethods
      def needs_implementation(name, *args)
        self.class_eval do
          define_method(name) do |*args|
            raise NotImplemented
          end
        end
      end
    end
  end
end
