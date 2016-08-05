require 'rails_helper'

describe Dallal::Notifiers::SmsNotifier do
  let(:notification) do
    double("Notification", body: 'a message', from: '111', to: '222')
  end
  subject { Dallal::Notifiers::SmsNotifier.new(notification) }

  it { expect(subject).to be_a(Dallal::Notifiers::Notifier) }

  describe '.client' do
    it 'should return a twillio clinet' do
      client = subject.client
      expect(client).to be_a Twilio::REST::Client
    end
  end

  describe '#notify' do
    it 'should create a message with twillio reset client' do
      expect(subject.client).to receive_message_chain(:messages, :create).with(from: notification.from, to: notification.to, body: notification.body)
      subject.notify!
    end
  end

  describe '#persist'
end
