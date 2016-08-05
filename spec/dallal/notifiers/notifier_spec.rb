require 'rails_helper'

describe Dallal::Notifiers::Notifier do
  let(:notification) { double("Notification") }
  subject { Dallal::Notifiers::Notifier.new(notification) }
  it { expect(subject).to be_a Dallal::AbstractInterface }
  it { expect(subject.notification).to eq(notification) }

  describe "#persist!" do
    it 'should raise an error' do
      expect{ subject.persist! }.to raise_error(Dallal::AbstractInterface::InterfaceNotImplementedError)
    end
  end

  describe "#notify" do
    it 'should raise an error' do
      expect{ subject.notify! }.to raise_error(Dallal::AbstractInterface::InterfaceNotImplementedError)
    end
  end
end
