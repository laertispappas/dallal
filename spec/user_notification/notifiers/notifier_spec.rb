require 'rails_helper'

describe UserNotification::Notifiers::Notifier do
  let(:notification) { double("Notification") }
  subject { UserNotification::Notifiers::Notifier.new(notification) }
  it { expect(subject).to be_a UserNotification::AbstractInterface }

  context '.sms' do
    it 'return a sms notifier' do
      result = UserNotification::Notifiers::Notifier.sms(notification)
      expect(result).to be_a(UserNotification::Notifiers::SmsNotifier)
      expect(result.notification).to eq notification
    end
  end
  context '.email' do
    it 'returns an email notifier' do
      result = UserNotification::Notifiers::Notifier.email(notification)
      expect(result).to be_a(UserNotification::Notifiers::EmailNotifier)
      expect(result.notification).to eq notification
    end
  end
  describe "#notify" do
    it 'should raise an error' do
      expect{ subject.notify! }.to raise_error(UserNotification::AbstractInterface::InterfaceNotImplementedError)
    end
  end
end
