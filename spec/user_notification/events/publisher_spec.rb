require 'rails_helper'

describe UserNotification::Events::Publisher do
  subject { UserNotification::Events::EventPublisher }

  describe '.broadcast' do
    it 'brodcasts an event to with ActiveSupport::Notification.instrument' do
      payload = { a: 1, b: 2 }
      expect(ActiveSupport::Notifications).to receive(:instrument).with(
        subject.pub_sub_namespace, payload).and_call_original
      subject.broadcast(payload)
    end
  end
end
