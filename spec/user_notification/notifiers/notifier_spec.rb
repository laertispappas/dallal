require 'rails_helper'

describe UserNotification::Notifiers::Notifier do
  it { expect(subject).to be_a UserNotification::AbstractInterface }

  describe "#notify" do
    it 'should raise an error' do
      expect{ subject.notify }.to raise_error(UserNotification::AbstractInterface::InterfaceNotImplementedError)
    end
  end
end
