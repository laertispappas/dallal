require 'rails_helper'

describe Dallal::Notifiers::Notifier do
  let(:notification) { double("Notification") }
  subject { Dallal::Notifiers::Notifier.new(notification) }
  it { expect(subject).to be_a Dallal::AbstractInterface }

  context '.sms' do
    it 'return a sms notifier' do
      result = Dallal::Notifiers::Notifier.sms(notification)
      expect(result).to be_a(Dallal::Notifiers::SmsNotifier)
      expect(result.notification).to eq notification
    end
  end
  context '.email' do
    it 'returns an email notifier' do
      result = Dallal::Notifiers::Notifier.email(notification)
      expect(result).to be_a(Dallal::Notifiers::EmailNotifier)
      expect(result.notification).to eq notification
    end
  end
  describe "#notify" do
    it 'should raise an error' do
      expect{ subject.notify! }.to raise_error(Dallal::AbstractInterface::InterfaceNotImplementedError)
    end
  end
end
